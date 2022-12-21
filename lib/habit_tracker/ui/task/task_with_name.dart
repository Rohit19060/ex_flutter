import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../../models/task.dart';
import '../common_widgets/edit_task_button.dart';
import '../theming/app_theme.dart';
import 'animated_task.dart';

class TaskWithName extends StatelessWidget {
  const TaskWithName({
    super.key,
    required this.task,
    this.completed = false,
    this.isEditing = false,
    this.hasCompletedState = true,
    this.onCompleted,
    this.editTaskButtonBuilder,
  });
  final Task task;
  final bool completed;
  final bool isEditing;
  final bool hasCompletedState;
  final ValueChanged<bool>? onCompleted;
  final WidgetBuilder? editTaskButtonBuilder;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              children: [
                AnimatedTask(
                  iconName: task.iconName,
                  completed: completed,
                  isEditing: isEditing,
                  hasCompletedState: hasCompletedState,
                  onCompleted: onCompleted,
                ),
                if (editTaskButtonBuilder != null)
                  Positioned.fill(
                    child: FractionallySizedBox(
                      widthFactor: EditTaskButton.scaleFactor,
                      heightFactor: EditTaskButton.scaleFactor,
                      alignment: Alignment.bottomRight,
                      child: editTaskButtonBuilder!(context),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 39,
            child: Text(
              task.name.toUpperCase(),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyles.taskName
                  .copyWith(color: AppTheme.of(context).accent),
            ),
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder?>.has(
        'editTaskButtonBuilder', editTaskButtonBuilder));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has(
        'onCompleted', onCompleted));
    properties
        .add(DiagnosticsProperty<bool>('hasCompletedState', hasCompletedState));
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
    properties.add(DiagnosticsProperty<bool>('completed', completed));
    properties.add(DiagnosticsProperty<Task>('task', task));
  }
}
