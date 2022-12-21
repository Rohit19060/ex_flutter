import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../animations/animation_controller_state.dart';
import '../common_widgets/centered_svg_icon.dart';
import '../theming/app_theme.dart';
import 'task_completion_ring.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask({
    super.key,
    required this.iconName,
    required this.completed,
    this.isEditing = false,
    this.hasCompletedState = true,
    this.onCompleted,
  });
  final String iconName;
  final bool isEditing;
  final bool hasCompletedState;
  final bool completed;
  final ValueChanged<bool>? onCompleted;

  @override
  _AnimatedTaskState createState() =>
      _AnimatedTaskState(const Duration(milliseconds: 750));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has(
        'onCompleted', onCompleted));
    properties.add(DiagnosticsProperty<bool>('completed', completed));
    properties
        .add(DiagnosticsProperty<bool>('hasCompletedState', hasCompletedState));
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
    properties.add(StringProperty('iconName', iconName));
  }
}

class _AnimatedTaskState extends AnimationControllerState<AnimatedTask> {
  _AnimatedTaskState(super.duration);
  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_checkStatusUpdates);
    _curveAnimation =
        animationController.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_checkStatusUpdates);
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCompleted?.call(true);
      if (widget.hasCompletedState) {
        if (mounted) {
          setState(() => _showCheckIcon = true);
        }
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _showCheckIcon = false);
          }
        });
      } else {
        animationController.value = 0.0;
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEditing &&
        !widget.completed &&
        animationController.status != AnimationStatus.completed) {
      animationController.forward();
    } else if (!_showCheckIcon) {
      widget.onCompleted?.call(false);
      animationController.value = 0.0;
    }
  }

  void _handleTapCancel() {
    if (!widget.isEditing &&
        animationController.status != AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: (_) => _handleTapCancel(),
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _curveAnimation,
          builder: (context, child) {
            final themeData = AppTheme.of(context);
            final progress = widget.completed ? 1.0 : _curveAnimation.value;
            final hasCompleted = progress == 1.0;
            final iconColor =
                hasCompleted ? themeData.accentNegative : themeData.taskIcon;
            return Stack(
              children: [
                TaskCompletionRing(progress: progress),
                Positioned.fill(
                  child: CenteredSvgIcon(
                    iconName: hasCompleted && _showCheckIcon
                        ? AppAssets.check
                        : widget.iconName,
                    color: iconColor,
                  ),
                ),
              ],
            );
          },
        ),
      );
}
