import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../k_padding.dart';
import '../models/product_item.dart';
import '../responsive_layout.dart';
import 'e_com_drawer.dart';
import 'e_com_item_description.dart';
import 'items/categories.dart';
import 'items/e_commerce_item.dart';

class ECommerceItems extends StatefulWidget {
  const ECommerceItems({
    Key? key,
  }) : super(key: key);

  @override
  State<ECommerceItems> createState() => _ECommerceItemsState();
}

class _ECommerceItemsState extends State<ECommerceItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const ECommerceDrawer(),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: kIsWeb ? kPadding : 0),
        color: Theme.of(context).colorScheme.secondary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(
                    width: kPadding,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kPadding, vertical: 4),
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Search',
                          fillColor: Colors.white.withOpacity(0.5),
                          filled: true,
                          suffixIcon: const Padding(
                            padding: EdgeInsets.all(kPadding * 0.70),
                            child: Icon(Icons.search),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*  if (!ResponsiveLayout.isMacbook(context))
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ), */
                  const SizedBox(width: kPadding / 2)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: Text(
                  'Sellar eCommerce',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Categories(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: kPadding,
                      crossAxisSpacing: kPadding,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) => ECommerceItem(
                      selected: ResponsiveLayout.isIphone(context)
                          ? false
                          : index == 0,
                      item: products[index],
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ECommerceItemDescription(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
