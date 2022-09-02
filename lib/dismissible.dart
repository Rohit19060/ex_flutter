import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Map<String, dynamic>> cart = [
    {
      'id': 'p1',
      'title': 'Red Shirt',
      'price': 50,
      'quantity': 1,
      'productId': 'p1',
    },
    {
      'id': 'p2',
      'title': 'Blue Shirt',
      'price': 50,
      'quantity': 1,
      'productId': 'p2',
    },
    {
      'id': 'p3',
      'title': 'Green Shirt',
      'price': 50,
      'quantity': 1,
      'productId': 'p3',
    },
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: Scaffold(
          body: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) => CartItem(
              id: cart[index]['id'].toString(),
              title: cart[index]['title'].toString(),
              price: num.parse(cart[index]['price'].toString()),
              quantity: int.parse(cart[index]['quantity'].toString()),
              productId: cart[index]['productId'].toString(),
            ),
          ),
        ),
      );
}

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  });
  final String id, productId, title;
  final num price;
  final int quantity;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
        child: Dismissible(
          key: ValueKey(id),
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).colorScheme.error,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
            padding: const EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white, size: 40),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // removeItem(productId);
          },
          confirmDismiss: (direction) => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you Sure?'),
              content:
                  const Text('Do you want to remote the item from the Cart?'),
              actions: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('₹ $price'),
                  )),
                ),
                title: Text(title),
                subtitle: Text('Total ₹ ${price * quantity}'),
                trailing: Text('x $quantity'),
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(IntProperty('quantity', quantity));
    properties.add(StringProperty('productId', productId));
    properties.add(StringProperty('id', id));
    properties.add(DiagnosticsProperty<num>('price', price));
  }
}
