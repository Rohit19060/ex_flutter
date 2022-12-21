import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../persistence/hive_data_store.dart';
import '../home/home_page.dart';
import 'onboarding_page.dart';

class HomeOrOnboarding extends ConsumerWidget {
  const HomeOrOnboarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.didAddFirstTaskListenable(),
      builder: (_, box, __) => dataStore.didAddFirstTask(box)
          ? const HomePage()
          : const OnboardingPage(),
    );
  }
}
