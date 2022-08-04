import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomMultiChildLayout(
          delegate: YourLayoutDelegate(position: Offset.zero),
          children: <LayoutId>[
            LayoutId(
              id: 1,
              child: const Text('Widget one'),
            ),
            LayoutId(
              id: 2,
              child: const Text('Widget two'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      );
}

class YourLayoutDelegate extends MultiChildLayoutDelegate {
  YourLayoutDelegate({required this.position});

  final Offset position;

  @override
  void performLayout(Size size) {
    var leadingSize = Size.zero;

    if (hasChild(1)) {
      leadingSize = layoutChild(
        1,
        BoxConstraints.loose(size),
      );
    }

    if (hasChild(2)) {
      layoutChild(
        2,
        BoxConstraints(
          maxWidth: size.width,
          maxHeight: size.height,
        ),
      );

      positionChild(
        2,
        Offset(
          leadingSize.width,
          size.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(YourLayoutDelegate oldDelegate) =>
      oldDelegate.position != position;
}
