import 'package:flutter_test/flutter_test.dart';

import '../stuff/unit_tests/counter.dart';

void main() {
  late Counter counter;
  setUp(() {
    // This is run before each test
    counter = Counter();
  });
  setUpAll(() {
    // This is run once before all tests
  });

  group('Counter test', () {
    test('Counter value should be zero at start', () {
      // Arrange

      // Act

      // Assert
      expect(counter.count, 0);
    });

    test(
        'given counter class when it is incremented then the value of count should be incremented',
        () {
      // Arrange

      // Act
      counter.increment();

      // Assert
      expect(counter.count, 1);
    });

    test(
        'given counter class when it is decremented then the value of count should be decremented',
        () {
      // Arrange

      // Act
      counter.decrement();

      // Assert
      expect(counter.count, -1);
    });

    test(
        'given counter class when it is reset then the value of count should be zero',
        () {
      // Arrange

      // Act
      counter.reset();

      // Assert
      expect(counter.count, 0);
    });

    tearDown(() {
      // This is run after each test
    });
    tearDownAll(() {
      // This is run once after all tests
    });
  });
}
