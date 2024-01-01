import 'package:hive/hive.dart';

import '../constants/app_colors.dart';
import '../ui/theming/app_theme.dart';
import 'front_or_back_side.dart';

part 'app_theme_settings.g.dart';

@HiveType(typeId: 2)
class AppThemeSettings {
  AppThemeSettings({required this.colorIndex, required this.variantIndex});
  factory AppThemeSettings.defaults(FrontOrBackSide side) => AppThemeSettings(
        colorIndex: 0,
        variantIndex: side == FrontOrBackSide.front ? 0 : 2,
      );
  // Index used to reference one of the colors in AppColors
  // Can range between 0 and allColors.length - 1
  @HiveField(0)
  final int colorIndex;

  // Index used to reference the currently selected variant for each color
  // Can range between 0 and 2
  @HiveField(1)
  final int variantIndex;

  AppThemeSettings copyWith({
    int? colorIndex,
    int? variantIndex,
  }) =>
      AppThemeSettings(
        colorIndex: colorIndex ?? this.colorIndex,
        variantIndex: variantIndex ?? this.variantIndex,
      );

  // actual AppThemeData object to be used by widgets
  AppThemeData get themeData {
    final variants = AppThemeVariants(allSwatches[colorIndex]);
    return variants.themes[variantIndex];
  }
}
