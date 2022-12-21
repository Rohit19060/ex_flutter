import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/meal.dart';

class MealsDetailScreen extends StatelessWidget {
  const MealsDetailScreen({required this.meal});
  final Meal meal;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFE9E9E9),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              backgroundColor: const Color(0xFF200087),
              expandedHeight: 300.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40.0),
                  ),
                  child: Image.asset(
                    meal.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 20.0,
                  ),
                  ListTile(
                    title: Text(
                      meal.mealTime,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey,
                      ),
                    ),
                    subtitle: Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              '${meal.kiloCaloriesBurnt} kcal',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${meal.timeTaken} mins',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'INGREDIENTS',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (int i = 0; i < meal.ingredients.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              meal.ingredients[i],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'PREPARTION',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 32.0,
                    ),
                    child: Text(
                      meal.preparation,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Meal>('meal', meal));
  }
}
