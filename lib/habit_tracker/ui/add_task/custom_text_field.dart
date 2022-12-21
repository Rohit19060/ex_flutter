import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../common_widgets/chevron_icon.dart';
import '../theming/app_theme.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.initialValue = '',
    this.hintText = '',
    this.showChevron = false,
    this.onSubmit,
  });
  final String initialValue;
  final String hintText;
  final bool showChevron;
  final ValueChanged<String>? onSubmit;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<ValueChanged<String>?>.has('onSubmit', onSubmit));
    properties.add(DiagnosticsProperty<bool>('showChevron', showChevron));
    properties.add(StringProperty('hintText', hintText));
    properties.add(StringProperty('initialValue', initialValue));
  }
}

class CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;

  String get text => _controller.value.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  void _clearText() {
    _controller.clear();
    // * This empty call to setState forces a rebuild which will hide the chevron.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Container(
        color: AppTheme.of(context).secondary,
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                // * This empty call to setState forces a rebuild which may show/hide the chevron.
                onChanged: (value) => setState(() {}),
                onSubmitted: (value) => widget.onSubmit?.call(value),
                controller: _controller,
                cursorColor: AppTheme.of(context).settingsText,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyles.content.copyWith(
                  color: AppTheme.of(context).settingsText,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyles.content.copyWith(
                      color:
                          AppTheme.of(context).settingsText.withOpacity(0.4)),
                  suffixIcon: text.isNotEmpty
                      ? IconButton(
                          onPressed: _clearText,
                          icon: Icon(
                            Icons.cancel,
                            color: AppTheme.of(context).settingsText,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
            if (text.isNotEmpty && widget.showChevron)
              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                color: AppTheme.of(context).settingsListIconBackground,
                child: IconButton(
                  onPressed: () => widget.onSubmit?.call(text),
                  icon: const ChevronIcon(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}
