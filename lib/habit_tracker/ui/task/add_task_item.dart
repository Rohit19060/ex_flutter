import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../models/task.dart';
import 'task_with_name.dart';

class AddTaskItem extends StatelessWidget {
  const AddTaskItem({super.key, this.onCompleted});
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) => TaskWithName(
        task: Task(
          id: '',
          name: 'Add a task',
          iconName: plus,
        ),
        hasCompletedState: false,
        onCompleted: (completed) => onCompleted?.call(),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onCompleted', onCompleted));
  }
}
