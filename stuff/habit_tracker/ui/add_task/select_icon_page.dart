import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../common_widgets/app_bar_icon_button.dart';
import '../common_widgets/centered_svg_icon.dart';
import '../theming/app_theme.dart';

class SelectIconPage extends StatelessWidget {
  const SelectIconPage({super.key, required this.selectedIconName});
  final String selectedIconName;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).secondary,
          leading: AppBarIconButton(
            iconName: navigationClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Select Icon',
            style: TextStyles.heading.copyWith(
              color: AppTheme.of(context).settingsText,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: AppTheme.of(context).primary,
        body: SelectIconGrid(
          selectedIconName: selectedIconName,
          onSelectedIcon: (iconName) => Navigator.of(context).pop(iconName),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('selectedIconName', selectedIconName));
  }
}

class SelectIconGrid extends StatefulWidget {
  const SelectIconGrid(
      {super.key, required this.selectedIconName, this.onSelectedIcon});
  final String selectedIconName;
  final ValueChanged<String>? onSelectedIcon;
  @override
  State<SelectIconGrid> createState() => _SelectIconGridState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has(
        'onSelectedIcon', onSelectedIcon));
    properties.add(StringProperty('selectedIconName', selectedIconName));
  }
}

class _SelectIconGridState extends State<SelectIconGrid> {
  late String _selectedIconName = widget.selectedIconName;

  void _select(String selectedIconName) {
    // * If the currently selected icon is chosen again
    if (_selectedIconName == selectedIconName) {
      // * call the callback, which will dismiss the page and return the icon name
      widget.onSelectedIcon?.call(selectedIconName);
    } else {
      // * Otherwise update the state (but don't call anything just yet)
      setState(() => _selectedIconName = selectedIconName);
    }
  }

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          final iconName = allTaskIcons[index];
          return SelectTaskIcon(
            iconName: iconName,
            isSelected: _selectedIconName == iconName,
            onPressed: () => _select(iconName),
          );
        },
        itemCount: allTaskIcons.length,
      );
}

class SelectTaskIcon extends StatelessWidget {
  const SelectTaskIcon({
    super.key,
    required this.iconName,
    required this.isSelected,
    this.onPressed,
  });
  final String iconName;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppTheme.of(context).accent
                : AppTheme.of(context).settingsInactiveIconBackground,
          ),
          child: CenteredSvgIcon(
            iconName: iconName,
            color: isSelected
                ? AppTheme.of(context).accentNegative
                : white,
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(StringProperty('iconName', iconName));
  }
}
