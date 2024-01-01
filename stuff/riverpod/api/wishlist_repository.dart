import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repositoryProvider = Provider.family<WishlistRepository, String>(
    (_, data) => WishlistRepository(data));

class WishlistRepository {
  WishlistRepository(this.clientId);
  final String clientId;
  Dio get _client =>
      Dio(BaseOptions(baseUrl: 'https://reqres.in/api/users?page=2'));
  Future<List<BoardGame>> getBoardGames() async {
    final result =
        (await _client.get('/search?limit=20')).data as Map<String, dynamic>;
    final games = result['data'] as List<dynamic>;
    return games
        .map((e) => BoardGame.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BoardGame {
  const BoardGame({
    required this.id,
    required this.email,
    required this.firstName,
    required this.avatar,
  });

  factory BoardGame.fromJson(Map<String, dynamic> json) => BoardGame(
        id: json['id'] as int,
        email: json['email'] as String,
        firstName: json['first_name'] as String,
        avatar: json['avatar'] as String,
      );

  final String email, firstName, avatar;
  final int id;
}

final wishlistFutureProvider = FutureProvider<List<BoardGame>>((ref) {
  final repository = ref.read(repositoryProvider('Rohit Jain'));
  return repository.getBoardGames();
});
