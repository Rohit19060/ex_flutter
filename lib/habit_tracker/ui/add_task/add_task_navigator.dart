import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/front_or_back_side.dart';
import '../../models/task.dart';
import '../../models/task_preset.dart';
import 'add_task_page.dart';
import 'task_details_page.dart';

class AddTaskRoutes {
  static const root = '/';
  static const confirmTask = '/confirmTask';
}

class AddTaskNavigator extends StatelessWidget {
  const AddTaskNavigator({super.key, required this.frontOrBackSide});
  final FrontOrBackSide frontOrBackSide;

  @override
  Widget build(BuildContext context) => Navigator(
        initialRoute: AddTaskRoutes.root,
        onGenerateRoute: (routeSettings) => MaterialPageRoute(
          builder: (context) {
            switch (routeSettings.name) {
              case AddTaskRoutes.root:
                return AddTaskPage();
              case AddTaskRoutes.confirmTask:
                final taskPreset = routeSettings.arguments! as TaskPreset;
                final task = Task.create(
                  name: taskPreset.name,
                  iconName: taskPreset.iconName,
                );
                return TaskDetailsPage(
                  task: task,
                  isNewTask: true,
                  frontOrBackSide: frontOrBackSide,
                );
              default:
                throw UnimplementedError();
            }
          },
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(EnumProperty<FrontOrBackSide>('frontOrBackSide', frontOrBackSide));
  }
}
