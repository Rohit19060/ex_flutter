import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utilities/methods.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: const MyApp()));
}

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SettingsRepository {
  const SettingsRepository(this.ref);
  final Ref ref;

  String get userId =>
      ref.read(sharedPreferencesProvider).getString('x-user-id') ?? '';

  set userId(String x) =>
      ref.read(sharedPreferencesProvider).setString('x-user-id', x);

  String get token =>
      ref.read(sharedPreferencesProvider).getString('x-user-token') ?? '';

  set token(String x) =>
      ref.read(sharedPreferencesProvider).setString('x-user-token', x);

  void clearSharedPrefs() {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    sharedPreferences.clear();
  }
}

final settingsRepositoryProvider =
    Provider<SettingsRepository>(SettingsRepository.new);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              InkWell(
                onTap: () async {
                  final res = await networkRequest('customerLogin',
                      formData: {
                        'mobile_no': '8888221323',
                        'password': '123456'
                      },
                      isPost: true);
                  if (res.status) {
                    try {
                      final data = (res.data as Map<String, dynamic>)['result']
                          as Map<String, dynamic>;
                      final prefs = ref.read(settingsRepositoryProvider);
                      prefs.userId = data['customerID'].toString();
                      prefs.token = data['api_token'].toString();
                      final res2 = await networkRequest('customerProfile',
                          formData: {'cid': prefs.userId});
                      if (res2.status) {
                        if (mounted) {
                          debugPrint('Navigate to Home');
                          setState(() {});
                        }
                      } else {
                        debugPrint(res2.message);
                      }
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  } else {
                    debugPrint(res.message);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('HI'),
                ),
              ),
              Text(ref.read(settingsRepositoryProvider).userId),
              Text(ref.read(settingsRepositoryProvider).token),
            ],
          ),
        ),
      );
}
