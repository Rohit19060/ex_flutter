import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal.dart';
import '../../ui/pages/workout_screen.dart';
import '../widgets/build_ingredient_progress.dart';
import '../widgets/build_meal_item_card.dart';
import '../widgets/build_radial_progress.dart';
import '../widgets/build_workout_image_item.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
        child: BottomNavigationBar(
          iconSize: 40.0,
          selectedIconTheme: const IconThemeData(color: Color(0xFF200087)),
          unselectedIconTheme: const IconThemeData(color: Colors.black12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            height: height * 0.35,
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40.0)),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 32.0,
                  right: 16.0,
                  bottom: 10.0,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '${DateFormat.EEEE().format(today)}, ${DateFormat('d MMMM').format(today)}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: const Text(
                        'Hello, David',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: ClipOval(
                          child: Image.asset('assets/images/user.jpg')),
                    ),
                    Row(
                      children: <Widget>[
                        BuildRadialProgress(
                          height: width * 0.3,
                          width: width * 0.3,
                          progress: 0.7,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            BuildIngredientProgress(
                              ingredientName: 'Protein',
                              progress: 0.3,
                              progressColor: Colors.green,
                              leftAmount: 72,
                              width: width * 0.28,
                            ),
                            const SizedBox(height: 10),
                            BuildIngredientProgress(
                              ingredientName: 'Carbs',
                              progress: 0.2,
                              progressColor: Colors.red,
                              leftAmount: 252,
                              width: width * 0.28,
                            ),
                            const SizedBox(height: 10),
                            BuildIngredientProgress(
                              ingredientName: 'Fat',
                              progress: 0.1,
                              progressColor: Colors.yellow,
                              leftAmount: 62,
                              width: width * 0.28,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.37,
            left: 0,
            right: 0,
            child: SizedBox(
              height: height * 0.52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      'MEALS FOR TODAY',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 32.0),
                          for (int i = 0; i < meals.length; i++)
                            BuildMealItemCard(meal: meals[i]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: OpenContainer(
                      closedColor: const Color(0xFFE9E9E9),
                      closedElevation: 0.0,
                      transitionDuration: const Duration(milliseconds: 1000),
                      openBuilder: (context, _) => const WorkoutScreen(),
                      closedBuilder: (context, openContainer) => InkWell(
                        onTap: openContainer,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF20008B),
                                Color(0xFF200087),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 16.0,
                                  left: 16.0,
                                ),
                                child: Text(
                                  'YOUR NEXT WORKOUT',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0, left: 16),
                                child: Text(
                                  'Upper Body',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const <Widget>[
                                    BuildWorkoutImageItem(
                                      image: 'assets/images/chest.png',
                                      radius: 25.0,
                                      width: 50.0,
                                      height: 50.0,
                                      padding: 10.0,
                                    ),
                                    BuildWorkoutImageItem(
                                      image: 'assets/images/back.png',
                                      radius: 25.0,
                                      width: 50.0,
                                      height: 50.0,
                                      padding: 10.0,
                                    ),
                                    BuildWorkoutImageItem(
                                      image: 'assets/images/biceps.png',
                                      radius: 25.0,
                                      width: 50.0,
                                      height: 50.0,
                                      padding: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('today', today));
  }
}
