import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnchoredOverlay extends StatelessWidget {
  const AnchoredOverlay({
    super.key,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  });
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (overlayContext) {
              final box = context.findRenderObject()! as RenderBox;
              final center = box.size.center(box.localToGlobal(Offset.zero));

              return overlayBuilder(overlayContext, center);
            },
            child: child,
          ));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext p1, Offset anchor)>.has(
            'overlayBuilder', overlayBuilder));
    properties.add(DiagnosticsProperty<bool>('showOverlay', showOverlay));
  }
}

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({
    super.key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  @override
  State<OverlayBuilder> createState() => _OverlayBuilderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Function(BuildContext p1)>.has(
        'overlayBuilder', overlayBuilder));
    properties.add(DiagnosticsProperty<bool>('showOverlay', showOverlay));
  }
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncWidgetAndOverlay();
  }

  @override
  void reassemble() {
    super.reassemble();
    syncWidgetAndOverlay();
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }
    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder as Widget Function(BuildContext),
    );
    addToOverlay(overlayEntry!);
  }

  Future<void> addToOverlay(OverlayEntry entry) async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context)!.insert(entry);
    });
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<OverlayEntry?>('overlayEntry', overlayEntry));
  }
}

class CenterAbout extends StatelessWidget {
  const CenterAbout({super.key, required this.position, required this.child});
  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
        top: position.dy,
        left: position.dx,
        child: FractionalTranslation(
          translation: const Offset(-0.5, -0.5),
          child: child,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('position', position));
  }
}
