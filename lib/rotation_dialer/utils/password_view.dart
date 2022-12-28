import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';

import '../rotation_dialer/constant.dart';
import '../rotation_dialer/dialer_input.dart';
import '../simple_dialer/simple_input.dart';
import '../widgets/input_button.dart';
import 'password_digits.dart';

const _animationDuration = Duration(milliseconds: 500);
const _padding = 16.0;

class PasswordInputView extends StatefulWidget {
  const PasswordInputView({
    required this.expectedCode,
    required this.onSuccess,
    required this.onError,
    super.key,
  });

  final String expectedCode;
  final VoidCallback onSuccess;
  final VoidCallback onError;

  @override
  State<PasswordInputView> createState() => _PasswordInputViewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onError', onError));
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onSuccess', onSuccess));
    properties.add(StringProperty('expectedCode', expectedCode));
  }
}

class _PasswordInputViewState extends State<PasswordInputView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _modeChangeController;

  late List<PasswordDigit> _passcodeDigitValues;
  var _currentInputIndex = 0;

  var _simpleInputMode = false;
  var _passcodeAnimationInProgress = false;

  bool get _isAnimating =>
      _modeChangeController.isAnimating || _passcodeAnimationInProgress;

  @override
  void initState() {
    super.initState();

    _modeChangeController = AnimationController(
      duration: _animationDuration * 2,
      vsync: this,
    )..addListener(() => setState(() {}));

    _resetDigits();
  }

  @override
  void dispose() {
    _modeChangeController.dispose();

    super.dispose();
  }

  void _onDigitSelected(int index, {bool autovalidate = false}) {
    if (_isAnimating) {
      return;
    }

    final digitValue = _passcodeDigitValues[_currentInputIndex];

    setState(() {
      _passcodeDigitValues[_currentInputIndex++] = digitValue.copyWith(
        value: RotaryDialConstants.inputValues[index],
      );
    });

    if (autovalidate) {
      _validatePasscode();
    }
  }

  void _resetDigits() => setState(() {
        _currentInputIndex = 0;
        _passcodeDigitValues = List.generate(
          widget.expectedCode.length,
          (index) => const PasswordDigit(
            backgroundColor: Colors.white,
            fontColor: Colors.white,
          ),
          growable: false,
        );
      });

  Future<void> _validatePasscode() async {
    if (_isAnimating) {
      return;
    }

    final expectedCode = widget.expectedCode;

    if (_currentInputIndex != expectedCode.length) {
      return;
    }

    final interval = _animationDuration.inMilliseconds ~/ expectedCode.length;
    final codeInput = _passcodeDigitValues.fold<String>(
      '',
      (code, element) => code += element.value?.toString() ?? '',
    );

    _togglePasscodeAnimation();

    if (codeInput == expectedCode) {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.green,
        fontColor: Colors.transparent,
        interval: interval,
      );

      widget.onSuccess();
    } else {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        interval: interval,
      );
      await Future.delayed(const Duration(seconds: 1));
      await _changePasscodeDigitColors(
        backgroundColor: Colors.white,
        fontColor: Colors.white,
        interval: interval,
      );

      widget.onError();
    }

    await Future.delayed(_animationDuration);
    _resetDigits();
    _togglePasscodeAnimation();
  }

  Future<void> _changePasscodeDigitColors({
    Color? backgroundColor,
    Color? fontColor,
    int interval = 0,
  }) async {
    for (var i = 0; i < _passcodeDigitValues.length; i++) {
      await Future.delayed(Duration(milliseconds: interval));

      setState(() {
        if (backgroundColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            backgroundColor: backgroundColor,
          );
        }

        if (fontColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            fontColor: fontColor,
          );
        }
      });
    }
  }

  void _togglePasscodeAnimation() => setState(
        () => _passcodeAnimationInProgress = !_passcodeAnimationInProgress,
      );

  void _onModeChanged() {
    if (_modeChangeController.isCompleted) {
      _changeInputMode();
      Future.delayed(_animationDuration, _modeChangeController.reverse);
    } else {
      _modeChangeController.forward().then((_) => _changeInputMode());
    }
  }

  void _changeInputMode() => setState(
        () => _simpleInputMode = !_simpleInputMode,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              _padding,
              _padding * 3,
              _padding,
              _padding * 2,
            ),
            child: LocalHeroScope(
              curve: Curves.easeInOut,
              duration: _animationDuration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter\npassword'.toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 32.0),
                  Align(
                    alignment: _simpleInputMode
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: PasswordDigits(
                      animationDuration: _animationDuration,
                      passcodeDigitValues: _passcodeDigitValues,
                      simpleInputMode: _simpleInputMode,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: _simpleInputMode
                        ? SimpleInput(
                            onDigitSelected: (index) => _onDigitSelected(
                              index,
                              autovalidate: true,
                            ),
                          )
                        : RotaryDialInput(
                            animationDuration: _animationDuration,
                            modeChangeController: _modeChangeController,
                            pagePadding: _padding,
                            passcodeAnimationInProgress:
                                _passcodeAnimationInProgress,
                            onDigitSelected: _onDigitSelected,
                            onValidatePasscode: _validatePasscode,
                          ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InputModeButton(
                      animationDuration: _animationDuration,
                      simpleInputMode: _simpleInputMode,
                      onModeChanged: _onModeChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
