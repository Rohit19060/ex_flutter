import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildIngredientProgress extends StatelessWidget {
  const BuildIngredientProgress(
      {super.key,
      required this.ingredientName,
      required this.leftAmount,
      required this.progress,
      required this.width,
      required this.progressColor});
  final String ingredientName;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ingredientName.toUpperCase(),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  Container(
                    height: 10.0,
                    width: width * progress,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),
              Text('$leftAmount g left')
            ],
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('progressColor', progressColor));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('progress', progress));
    properties.add(IntProperty('leftAmount', leftAmount));
    properties.add(StringProperty('ingredientName', ingredientName));
  }
}
