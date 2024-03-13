import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/app_theme_settings.dart';
import '../../models/task.dart';
import '../sliding_panel/sliding_panel.dart';
import '../sliding_panel/sliding_panel_animator.dart';
import '../sliding_panel/theme_selection_close.dart';
import '../sliding_panel/theme_selection_list.dart';
import '../theming/animated_app_theme.dart';
import '../theming/app_theme.dart';
import 'home_page_bottom_options.dart';
import 'tasks_grid.dart';

class TasksGridPage extends StatelessWidget {
  const TasksGridPage({
    super.key,
    required this.leftAnimatorKey,
    required this.rightAnimatorKey,
    required this.gridKey,
    required this.tasks,
    this.onFlip,
    required this.themeSettings,
    this.onColorIndexSelected,
    this.onVariantIndexSelected,
  });
  final GlobalKey<SlidingPanelAnimatorState> leftAnimatorKey;
  final GlobalKey<SlidingPanelAnimatorState> rightAnimatorKey;
  final GlobalKey<TasksGridState> gridKey;
  final List<Task> tasks;
  final VoidCallback? onFlip;
  final AppThemeSettings themeSettings;
  final ValueChanged<int>? onColorIndexSelected;
  final ValueChanged<int>? onVariantIndexSelected;

  void _enterEditMode() {
    leftAnimatorKey.currentState?.slideIn();
    rightAnimatorKey.currentState?.slideIn();
    gridKey.currentState?.enterEditMode();
  }

  void _exitEditMode() {
    leftAnimatorKey.currentState?.slideOut();
    rightAnimatorKey.currentState?.slideOut();
    gridKey.currentState?.exitEditMode();
  }

  @override
  Widget build(BuildContext context) => AnimatedAppTheme(
        data: themeSettings.themeData,
        duration: const Duration(milliseconds: 150),
        child: Builder(
          builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.of(context).overlayStyle,
            child: Scaffold(
              backgroundColor: AppTheme.of(context).primary,
              body: SafeArea(
                child: Stack(
                  children: [
                    TasksGridContents(
                      gridKey: gridKey,
                      tasks: tasks,
                      onFlip: onFlip,
                      onEnterEditMode: _enterEditMode,
                      onExitEditMode: _exitEditMode,
                    ),
                    Positioned(
                      bottom: 6,
                      left: 0,
                      width: SlidingPanel.leftPanelFixedWidth,
                      child: SlidingPanelAnimator(
                        key: leftAnimatorKey,
                        direction: SlideDirection.leftToRight,
                        child: ThemeSelectionClose(onClose: _exitEditMode),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 0,
                      width: MediaQuery.of(context).size.width -
                          SlidingPanel.leftPanelFixedWidth,
                      child: SlidingPanelAnimator(
                        key: rightAnimatorKey,
                        direction: SlideDirection.rightToLeft,
                        child: ThemeSelectionList(
                          currentThemeSettings: themeSettings,
                          availableWidth: MediaQuery.of(context).size.width -
                              SlidingPanel.leftPanelFixedWidth -
                              SlidingPanel.paddingWidth,
                          onColorIndexSelected: onColorIndexSelected,
                          onVariantIndexSelected: onVariantIndexSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has(
        'onVariantIndexSelected', onVariantIndexSelected));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has(
        'onColorIndexSelected', onColorIndexSelected));
    properties.add(
        DiagnosticsProperty<AppThemeSettings>('themeSettings', themeSettings));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onFlip', onFlip));
    properties.add(IterableProperty<Task>('tasks', tasks));
    properties.add(DiagnosticsProperty<GlobalKey<SlidingPanelAnimatorState>>(
        'rightAnimatorKey', rightAnimatorKey));
    properties.add(DiagnosticsProperty<GlobalKey<SlidingPanelAnimatorState>>(
        'leftAnimatorKey', leftAnimatorKey));
    properties.add(
        DiagnosticsProperty<GlobalKey<TasksGridState>>('gridKey', gridKey));
  }
}

class TasksGridContents extends StatelessWidget {
  const TasksGridContents({
    super.key,
    this.gridKey,
    required this.tasks,
    this.onFlip,
    this.onEnterEditMode,
    this.onExitEditMode,
  });
  final Key? gridKey;
  final List<Task> tasks;
  final VoidCallback? onFlip;
  final VoidCallback? onEnterEditMode;
  final VoidCallback? onExitEditMode;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TasksGrid(
                key: gridKey,
                tasks: tasks,
                onAddOrEditTask: onExitEditMode,
              ),
            ),
          ),
          HomePageBottomOptions(
            onFlip: onFlip,
            onEnterEditMode: onEnterEditMode,
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onExitEditMode', onExitEditMode));
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onEnterEditMode', onEnterEditMode));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onFlip', onFlip));
    properties.add(IterableProperty<Task>('tasks', tasks));
    properties.add(DiagnosticsProperty<Key?>('gridKey', gridKey));
  }
}