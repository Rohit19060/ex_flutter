import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/wishlist_repository.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(useMaterial3: true),
        home: const WishlistApp(),
      );
}


// ChangeNotifier
class WishlistApp extends ConsumerWidget {
  const WishlistApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishList = ref.watch(wishlistFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Experiments'),
      ),
      body: wishList.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(data[index].firstName),
            leading: Image.network(data[index].avatar),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Error')),
      ),
    );
  }
}

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
