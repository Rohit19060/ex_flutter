import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Notification System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        routes: <String, Widget Function(BuildContext)>{
          'red': (_) => const RedPage(payload: 'red'),
          'green': (_) => const GreenPage(),
        },
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String payload = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    init(initScheduled: true);
    listenNotifications();

    FirebaseMessaging.instance.getToken().then((String? token) {
      Clipboard.setData(ClipboardData(text: token));
      debugPrint('Token: $token');
    });

    // Gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      debugPrint('Initial Message: $message');
      /*  if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      } */
    });

    // Trigger when App is running in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          channelId: message.data['channelId'].toString(),
          channelName: message.data['channelName'].toString(),
          sound: message.notification!.android!.sound ?? 'default',
          payload: '',
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });

    // Trigger when App is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp: $message');
      // final routeFromMessage = message.data["route"];
      // Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  void listenNotifications() {
    onNotifications.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {
    if (payload != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RedPage(payload: payload)));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Flutter Notification System')),
      body: Column(
        children: [
          const Text('Main Screen'),
          Text('Payload: $payload'),
          ElevatedButton(
            child: const Text('Get Notification'),
            onPressed: () => showNotification(
              channelId: 'channel_id 1',
              channelName: 'channel_name 1',
              sound: 'siren',
              title: 'Testing Title',
              body: 'Testing Body',
              payload: 'green',
            ),
          ),
          ElevatedButton(
              child: const Text('Schedule Notification'),
              onPressed: () {
                showScheduledNotification(
                  channelId: 'channel_id 1',
                  channelName: 'channel_name 1',
                  sound: 'siren.mp3',
                  title: 'Testing Title',
                  body: 'Testing Body',
                  payload: 'green',
                  scheduledDate: DateTime.now().add(
                    const Duration(seconds: 5),
                  ),
                );
                const snackbar = SnackBar(
                  content: Text('Notification Scheduled'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(snackbar);
              }),
        ],
      ));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token', token));
    properties.add(StringProperty('payload', payload));
  }
}

class RedPage extends StatelessWidget {
  const RedPage({super.key, required this.payload});
  final String payload;
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: Text(
          'Red Screen: $payload',
          style: const TextStyle(color: Colors.red),
        ),
      ));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('payload', payload));
  }
}

class GreenPage extends StatelessWidget {
  const GreenPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
      body: Center(
          child: Text('Green Screen', style: TextStyle(color: Colors.green))));
}

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> onNotifications = BehaviorSubject<String?>();

Future<void> init({bool initScheduled = false}) async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOS = IOSInitializationSettings();
  const initializationSettings =
      InitializationSettings(android: android, iOS: iOS);
  if (initScheduled) {
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  // When the app is closed
  final details = await _notifications.getNotificationAppLaunchDetails();
  if (details != null && details.didNotificationLaunchApp) {
    onNotifications.add(details.payload);
  }
  await _notifications.initialize(
    initializationSettings,
    onSelectNotification: onNotifications.add,
  );
}

Future<void> showNotification({
  int id = 0,
  required String title,
  required String body,
  required String payload,
  required String channelId,
  required String channelName,
  required String sound,
}) async {
  _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(
        channelId: channelId,
        channelName: channelName,
        sound: sound,
      ),
      payload: payload);
}

Future<void> showScheduledNotification({
  int id = 0,
  required String title,
  required String body,
  required String payload,
  required String channelId,
  required String channelName,
  required String sound,
  required DateTime scheduledDate,
}) async =>
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      await _notificationDetails(
          channelId: channelId, channelName: channelName, sound: sound),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

Future<void> showScheduledDailyNotification({
  int id = 0,
  required String title,
  required String body,
  required String payload,
  required String channelId,
  required String channelName,
  required String sound,
  required DateTime scheduledDate,
}) async =>
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(const Time(8, 30, 23)),
      await _notificationDetails(
          channelId: channelId, channelName: channelName, sound: sound),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

tz.TZDateTime _scheduleDaily(Time time) {
  final now = tz.TZDateTime.now(tz.local);
  final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
      time.hour, time.minute, time.second);
  return scheduledDate.isBefore(now)
      ? scheduledDate.add(const Duration(days: 1))
      : scheduledDate;
}

tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
  final scheduledDate = _scheduleDaily(time);
  while (!days.contains(scheduledDate.weekday)) {
    scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> showScheduledWeeklyNotification({
  int id = 0,
  required String title,
  required String body,
  required String payload,
  required String channelId,
  required String channelName,
  required String sound,
  required DateTime scheduledDate,
}) async =>
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleWeekly(const Time(8, 30, 23),
          days: [DateTime.monday, DateTime.wednesday, DateTime.friday]),
      await _notificationDetails(
          channelId: channelId, channelName: channelName, sound: sound),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

Future<NotificationDetails> _notificationDetails({
  required String channelId,
  required String channelName,
  required String sound,
}) async =>
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
        sound: sound != 'default'
            ? RawResourceAndroidNotificationSound(sound)
            : null,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(
            await downloadFile(
              'https://images.unsplash.com/photo-1657963062468-472b9dabf100?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
              'large_icon',
            ),
          ),
          largeIcon: FilePathAndroidBitmap(
            await downloadFile(
              'https://i.imgur.com/w3duR07.png',
              'small_image',
            ),
          ),
        ),
      ),
      iOS: IOSNotificationDetails(
        presentSound: true,
        sound: sound,
        presentAlert: true,
      ),
    );

Future<void> cancel(int id) async => _notifications.cancel(id);

Future<void> cancelAll() async => _notifications.cancelAll();

Future<String> downloadFile(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}
