import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/wishlist_repository.dart';

final wishlistCNProvider = ChangeNotifierProvider(WishlistChangeNotifier.new);

enum LoadingState { progress, success, error }

class WishlistChangeNotifier extends ChangeNotifier {
  WishlistChangeNotifier(Ref ref)
      : _api = ref.read(repositoryProvider('8l3xEV0LlB'));

  final WishlistRepository _api;
  final games = <BoardGame>[];
  LoadingState loading = LoadingState.progress;

  void reloadGames() {
    loading = LoadingState.progress;
    notifyListeners();
    loadGames();
  }

  Future<void> loadGames() async {
    try {
      final response = await _api.getBoardGames();
      games.addAll(response);
      loading = LoadingState.success;
    } on Exception catch (_) {
      loading = LoadingState.error;
    }
    notifyListeners();
  }
}
