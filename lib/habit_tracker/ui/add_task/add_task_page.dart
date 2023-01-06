import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../constants/text_styles.dart';
import '../../models/task_preset.dart';
import '../common_widgets/app_bar_icon_button.dart';
import '../theming/app_theme.dart';
import 'add_task_navigator.dart';
import 'custom_text_field.dart';
import 'task_preset_list_tile.dart';
import 'text_field_header.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).secondary,
          leading: AppBarIconButton(
            iconName: navigationClose,
            // * Using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
            // * Remember that we show this page inside [AddTaskNavigator],
            // * which already contains a [Navigator])
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          title: Text(
            'Add Task',
            style: TextStyles.heading.copyWith(
              color: AppTheme.of(context).settingsText,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: AppTheme.of(context).primary,
        body: const AddTaskContents(),
      );
}

class AddTaskContents extends StatelessWidget {
  const AddTaskContents({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const TextFieldHeader('CREATE YOUR OWN:'),
                CustomTextField(
                  hintText: 'Enter task title...',
                  showChevron: true,
                  onSubmit: (value) => Navigator.of(context).pushNamed(
                    AddTaskRoutes.confirmTask,
                    arguments: TaskPreset(
                        iconName: value.substring(0, 1).toUpperCase(),
                        name: value),
                  ),
                ),
                const SizedBox(height: 32),
                const TextFieldHeader('OR CHOOSE A PRESET:'),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => TaskPresetListTile(
                taskPreset: TaskPreset.allPresets[index],
                onPressed: (taskPreset) => Navigator.of(context).pushNamed(
                  AddTaskRoutes.confirmTask,
                  arguments: taskPreset,
                ),
              ),
              childCount: TaskPreset.allPresets.length,
            ),
          ),
          // Account for safe area
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          )
        ],
      );
}
