import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/meal.dart';
import '../pages/meals_detail_screen.dart';

class BuildMealItemCard extends StatelessWidget {
  const BuildMealItemCard({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(
          right: 20.0,
          bottom: 10.0,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: OpenContainer(
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  closedElevation: 0.0,
                  transitionDuration: const Duration(milliseconds: 1000),
                  openBuilder: (context, _) => MealsDetailScreen(
                    meal: meal,
                  ),
                  closedBuilder: (context, openContainer) => InkWell(
                    onTap: openContainer,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      child: Image.asset(
                        meal.imagePath,
                        width: 150.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        meal.mealTime,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${meal.kiloCaloriesBurnt} kcal',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.access_time,
                            color: Colors.black12,
                            size: 15.0,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${meal.timeTaken} min',
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Meal>('meal', meal));
  }
}
