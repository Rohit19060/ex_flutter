import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(useMaterial3: true),
        home: const SettingScreen(),
      );
}

final gitHubTokenState = StateProvider<String>((ref) => '');

final themeMode = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsRepository {
  const SettingsRepository(this.ref);
  final Ref ref;

  Future<void> setGitHubToken(String token) {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    ref.read(gitHubTokenState.notifier).state = token;
    return sharedPreferences.setString('gitHubToken', token);
  }

  Future<void> clearSharedPrefs() async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.clear();
  }
}

class ThemeNotifier extends Notifier<ThemeMode> {
  ThemeNotifier() : super();
  @override
  ThemeMode build() {
    var theme = ThemeMode.system;
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final value = sharedPreferences.getBool('theme');
    switch (value) {
      case null:
        theme = ThemeMode.system;
        break;
      case true:
        theme = ThemeMode.dark;
        break;
      case false:
        theme = ThemeMode.light;
        break;
      default:
        theme = ThemeMode.system;
        break;
    }
    print('Theme build');
    print(theme);
    return theme;
  }

  Future<void> updateTheme({bool isDark = false}) async {
    print('updated theme called');
    print(isDark);
    print('Before State');
    print(state);
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    print('After State');
    print(state);
    await sharedPreferences.setBool('theme', isDark);
  }
}

final themProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

final settingsRepositoryProvider =
    Provider<SettingsRepository>(SettingsRepository.new);

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(sharedPreferencesProvider);
      final theme = prefs.getBool('theme') ?? false;
      ref.read(themeMode.notifier).state =
          theme ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeMode);
    return Scaffold(
      body: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: Icon(
              theme == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            title: const Text(
              'Dark Mode',
              style: TextStyle(color: Color.fromRGBO(12, 12, 13, 1)),
            ),
            onTap: () {
              ref.read(themeMode.notifier).state =
                  theme != ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
            },
            trailing: Switch.adaptive(
              value: theme == ThemeMode.dark,
              onChanged: (_) => ref.read(themeMode.notifier).state =
                  theme != ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
        ),
      ),
    );
  }
}

// ChangeNotifier
// class WishlistApp extends ConsumerWidget {
//   const WishlistApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final wishList = ref.watch(wishlistFutureProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Experiments'),
//       ),
//       body: wishList.when(
//         data: (data) => ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) => ListTile(
//             title: Text(data[index].firstName),
//             leading: Image.network(data[index].avatar),
//           ),
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => const Center(child: Text('Error')),
//       ),
//     );
//   }
// }

// Provider
// class WishlistApp extends ConsumerWidget {
//   const WishlistApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final wishList = ref.watch(wishlistFutureProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Experiments'),
//       ),
//       body: wishList.when(
//         data: (data) => ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) => ListTile(
//             title: Text(data[index].firstName),
//             leading: Image.network(data[index].avatar),
//           ),
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => const Center(child: Text('Error')),
//       ),
//     );
//   }
// }

final counterProvider = StateProvider((ref) => 0);

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Experiments'),
      ),
      body: Center(
        child: Text('You have pushed the button this many times: $counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
