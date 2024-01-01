class Counter {
  int _counter = 0;
  int get count => _counter;
  void increment() => _counter++;
  void decrement() => _counter--;
  void reset() => _counter = 0;
}
