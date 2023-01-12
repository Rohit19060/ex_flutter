import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../models/front_or_back_side.dart';
import '../../models/task.dart';
import '../add_task/add_task_navigator.dart';
import '../add_task/task_details_page.dart';
import '../animations/animation_controller_state.dart';
import '../animations/custom_fade_transition.dart';
import '../animations/staggered_scale_transition.dart';
import '../common_widgets/edit_task_button.dart';
import '../task/add_task_item.dart';
import '../task/task_with_name_loader.dart';
import '../theming/app_theme.dart';

class TasksGrid extends StatefulWidget {
  const TasksGrid({super.key, required this.tasks, this.onAddOrEditTask});
  final List<Task> tasks;
  final VoidCallback? onAddOrEditTask;

  @override
  AnimationControllerState<TasksGrid> createState() =>
      // ignore: no_logic_in_create_state
      TasksGridState(const Duration(milliseconds: 200));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onAddOrEditTask', onAddOrEditTask));
    properties.add(IterableProperty<Task>('tasks', tasks));
  }
}

class TasksGridState extends AnimationControllerState<TasksGrid> {
  TasksGridState(super.duration);

  bool _isEditing = false;

  void enterEditMode() {
    animationController.forward();
    setState(() => _isEditing = true);
  }

  void exitEditMode() {
    animationController.reverse();
    setState(() => _isEditing = false);
  }

  Future<void> _addNewTask(WidgetRef ref) async {
    // * Notify the parent widget that we need to exit the edit mode
    // * As a result, the parent widget will call exitEditMode() and
    // * the edit UI will be dismissed
    widget.onAddOrEditTask?.call();
    // * Short delay to wait for the animations to complete
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      final appThemeData = AppTheme.of(context);
      final frontOrBackSide =
          ref.read<FrontOrBackSide>(frontOrBackSideProvider);
      // * then, show the Add Task page
      await showCupertinoModalBottomSheet<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => AppTheme(
          data: appThemeData,
          child: AddTaskNavigator(frontOrBackSide: frontOrBackSide),
        ),
      );
    }
  }

  Future<void> _editTask(WidgetRef ref, Task task) async {
    // * Notify the parent widget that we need to exit the edit mode
    // * As a result, the parent widget will call exitEditMode() and
    // * the edit UI will be dismissed
    widget.onAddOrEditTask?.call();
    // * Short delay to wait for the animations to complete
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      final appThemeData = AppTheme.of(context);
      final frontOrBackSide =
          ref.read<FrontOrBackSide>(frontOrBackSideProvider);
      // * then, show the TaskDetailsPage
      await showCupertinoModalBottomSheet<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => AppTheme(
          data: appThemeData,
          child: TaskDetailsPage(
            task: task,
            isNewTask: false,
            frontOrBackSide: frontOrBackSide,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisSpacing = constraints.maxWidth * 0.05;
          final taskWidth = (constraints.maxWidth - crossAxisSpacing) / 2.0;
          const aspectRatio = 0.82;
          final taskHeight = taskWidth / aspectRatio;
          // Use max(x, 0.1) to prevent layout error when keyword is visible in modal page
          final mainAxisSpacing =
              max((constraints.maxHeight - taskHeight * 3) / 2.0, 0.1);
          final tasksLength = min(6, widget.tasks.length + 1);
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) =>
                Consumer(builder: (context, ref, _) {
              if (index == widget.tasks.length) {
                return CustomFadeTransition(
                  animation: animationController,
                  child: AddTaskItem(
                    onCompleted: _isEditing ? () => _addNewTask(ref) : null,
                  ),
                );
              }
              final task = widget.tasks[index];
              return TaskWithNameLoader(
                task: task,
                isEditing: _isEditing,
                editTaskButtonBuilder: (_) => StaggeredScaleTransition(
                  animation: animationController,
                  index: index,
                  child: EditTaskButton(
                    onPressed: () => _editTask(ref, task),
                  ),
                ),
              );
            }),
            itemCount: tasksLength,
          );
        },
      );
}
