import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../persistence/hive_data_store.dart';
import 'task_with_name.dart';

class TaskWithNameLoader extends ConsumerWidget {
  const TaskWithNameLoader({
    super.key,
    required this.task,
    this.isEditing = false,
    this.editTaskButtonBuilder,
  });
  final Task task;
  final bool isEditing;
  final WidgetBuilder? editTaskButtonBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.taskStateListenable(task: task),
      builder: (context, box, _) {
        final taskState = dataStore.taskState(box, task: task);
        return TaskWithName(
          task: task,
          completed: taskState.completed,
          isEditing: isEditing,
          onCompleted: (completed) {
            ref
                .read(dataStoreProvider)
                .setTaskState(task: task, completed: completed);
          },
          editTaskButtonBuilder: editTaskButtonBuilder,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder?>.has(
        'editTaskButtonBuilder', editTaskButtonBuilder));
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
    properties.add(DiagnosticsProperty<Task>('task', task));
  }
}
