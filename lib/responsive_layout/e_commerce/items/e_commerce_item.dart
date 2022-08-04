import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../k_padding.dart';
import '../../models/product_item.dart';

class ECommerceItem extends StatelessWidget {
  const ECommerceItem({
    super.key,
    required this.item,
    required this.onPressed,
    this.selected = false,
  });
  final ProductItem item;
  final Function() onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(kPadding),
              height: 180,
              width: 160,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(4, 4),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Hero(
                tag: '${item.uid}',
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPadding / 4),
              child: Text(
                item.title,
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            Text(
              '\$ ${item.amount}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: kPadding / 2,
            )
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(ObjectFlagProperty<Function()>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<ProductItem>('item', item));
  }
}
