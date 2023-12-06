import 'package:flutter/material.dart';
import 'package:flutter_experiments/animated_neumorphism.dart';
import 'package:flutter_experiments/unit_tests/functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late UserRepository userRepo;
  late MockHttpClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockHttpClient();
    userRepo = UserRepository(mockHttpClient);
  });
  group('get user function', () {
    test('giver user repo, status code is 200', () async {
      when(() => mockHttpClient.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'))).thenAnswer((_) async => Response(
          '''
            {
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "website": "hildegard.org"
}''',
          200));
      final user = await userRepo.getUser();
      expect(user, isA<User>());
    });
    test('giver user repo, status code not is 200 ', () async {
      when(() => mockHttpClient.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'))).thenAnswer((_) async => Response('{}', 400));
      final user = userRepo.getUser();
      expect(user, throwsException);
    });
  });

  group('Widget Testing', () {
    testWidgets('Given Counter is 0 when increment', (tested) async {
      await tested.pumpWidget(const MyApp());
      expect(find.text('0'), findsOneWidget);
      await tested.tap(find.byType(FloatingActionButton));
      await tested.pump();
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('Dynamic API calls test', () {
    testWidgets('Given API call when response is 200 then show data', (tested) async {
      final userList = [User(email: '', name: '', phone: '', website: ''), User(email: '', name: '', phone: '', website: '')];
      // Future<List<User>> getUserList() async => userList;
      await tested.pumpWidget(const MaterialApp(home: MyApp()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tested.pumpAndSettle();
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ListTile), findsNWidgets(userList.length));
      for (final user in userList) {
        expect(find.text(user.name), findsOneWidget);
      }
    });

    testWidgets('testAnimation', (test) async {
      await test.pumpWidget(const MaterialApp(home: AnimatedNeumorphism()));
      var containerFinder = find.byKey(const Key('container'));
      expect(containerFinder, findsOneWidget);
      var container = test.widget<Container>(containerFinder);
      expect(container.decoration, const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
      await test.pumpAndSettle();
      containerFinder = find.byKey(const Key('container'));
      expect(containerFinder, findsOneWidget);
      container = test.widget<Container>(containerFinder);
      expect(container.decoration, const BoxDecoration(color: Colors.black, shape: BoxShape.circle));
    });
  });
}
