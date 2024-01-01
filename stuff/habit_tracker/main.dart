import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_assets.dart';
import 'models/front_or_back_side.dart';
import 'persistence/hive_data_store.dart';
import 'ui/onboarding/home_or_onboarding.dart';
import 'ui/theming/app_theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();
  // await dataStore.createDemoTasks(
  //   frontTasks: [
  //     Task.create(name: 'Take Vitamins', iconName: vitamins),
  //     Task.create(name: 'Cycle to Work', iconName: bike),
  //     Task.create(name: 'Wash Your Hands', iconName: washHands),
  //     Task.create(name: 'Wear a Mask', iconName: mask),
  //     Task.create(name: 'Brush Your Teeth', iconName: toothbrush),
  //     //Task.create(name: 'Floss Your Teeth', iconName: dentalFloss),
  //   ],
  //   backTasks: [
  //     Task.create(name: 'Eat a Healthy Meal', iconName: carrot),
  //     Task.create(name: 'Walk the Dog', iconName: dog),
  //     Task.create(name: 'Do Some Coding', iconName: html),
  //     Task.create(name: 'Meditate', iconName: meditation),
  //     Task.create(name: 'Do 10 Pushups', iconName: pushups),
  //     //Task.create(name: 'Sleep 8 Hours', iconName: rest),
  //   ],
  //   force: false,
  // );
  final frontThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.front);
  final backThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.back);
  runApp(ProviderScope(
    overrides: [
      dataStoreProvider.overrideWithValue(dataStore),
      frontThemeManagerProvider.overrideWith(
        (ref) => AppThemeManager(
          themeSettings: frontThemeSettings,
          side: FrontOrBackSide.front,
          dataStore: dataStore,
        ),
      ),
      backThemeManagerProvider.overrideWith(
        (ref) => AppThemeManager(
          themeSettings: backThemeSettings,
          side: FrontOrBackSide.back,
          dataStore: dataStore,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Helvetica Neue',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        home: const HomeOrOnboarding(),
      );
}
