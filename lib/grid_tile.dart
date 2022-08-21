import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Grid Tile',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const ProductItem(),
      );
}

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.black87,
                  leading: IconButton(
                    onPressed: () {
                      // Toggle favorite status
                    },
                    icon: Icon(
                      DateTime.now() == DateTime.parse('2020-01-01')
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                  title: const Text(
                    'Product Name',
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //  Add to Cart
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Add Item to cart'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              //  Undo action
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ),
                child: const Hero(
                  tag: 'product_Id',
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/logo.png'),
                    image: NetworkImage(
                      'https://avatars.githubusercontent.com/u/39453065?v=4',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
