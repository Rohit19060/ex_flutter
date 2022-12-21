import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../models/task_preset.dart';
import '../common_widgets/chevron_icon.dart';
import '../common_widgets/selectable_tile.dart';
import '../theming/app_theme.dart';

class TaskPresetListTile extends StatelessWidget {
  const TaskPresetListTile({
    super.key,
    required this.taskPreset,
    this.showChevron = true,
    this.onPressed,
  });
  final TaskPreset taskPreset;
  final bool showChevron;
  final ValueChanged<TaskPreset>? onPressed;

  @override
  Widget build(BuildContext context) => SelectableTile(
        onPressed: () => onPressed?.call(taskPreset),
        builder: (context, isSelected) => Container(
          color: isSelected
              ? AppTheme.of(context).secondary.withOpacity(0.5)
              : AppTheme.of(context).secondary,
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.of(context).settingsListIconBackground,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                taskPreset.iconName,
                color: AppColors.white,
                width: 24,
                height: 24,
              ),
            ),
            title: Text(
              taskPreset.name,
              style: TextStyles.content.copyWith(
                color: AppTheme.of(context).settingsText,
              ),
            ),
            trailing: showChevron
                ? ChevronIcon(color: AppTheme.of(context).accent)
                : null,
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<TaskPreset>?>.has(
        'onPressed', onPressed));
    properties.add(DiagnosticsProperty<bool>('showChevron', showChevron));
    properties.add(DiagnosticsProperty<TaskPreset>('taskPreset', taskPreset));
  }
}
