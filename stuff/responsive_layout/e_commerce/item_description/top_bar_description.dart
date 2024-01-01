import 'package:flutter/material.dart';

import '../../k_padding.dart';
import '../../responsive_layout.dart';

class TopBarDescription extends StatelessWidget {
  const TopBarDescription({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Row(
          children: [
            if (ResponsiveLayout.isIphone(context)) const BackButton(),
            if (ResponsiveLayout.isMacBook(context))
              IconButton(
                icon: Icon(
                  Icons.print_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {},
              ),
            const Spacer(),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: 100,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: kPadding,
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary)),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.black.withOpacity(0.8)),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: kPadding),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: 100,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: kPadding,
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor)),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
}
