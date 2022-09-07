import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  const AnchoredOverlay({
    super.key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor)
      overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (overlayContext) {
            final box = context.findRenderObject()! as RenderBox;
            final topLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
            final bottomRight =
                box.size.bottomRight(box.localToGlobal(Offset.zero));
            final anchorBounds = Rect.fromLTRB(
              topLeft.dx,
              topLeft.dy,
              bottomRight.dx,
              bottomRight.dy,
            );
            final anchorCenter = box.size.center(topLeft);
            return overlayBuilder(overlayContext, anchorBounds, anchorCenter);
          },
          child: child,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<
        Widget Function(BuildContext p1, Rect anchorBounds,
            Offset anchor)>.has('overlayBuilder', overlayBuilder));
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
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  @override
  State<OverlayBuilder> createState() => _OverlayBuilderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1)>.has(
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
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: widget.overlayBuilder);
      addToOverlay(overlayEntry!);
    } else {
      buildOverlay();
    }
  }

  Future<void> addToOverlay(OverlayEntry entry) async {
    final overlay = Overlay.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => overlay!.insert(entry));
  }

  void hideOverlay() {
    overlayEntry!.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  Future<void> buildOverlay() async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => overlayEntry!.markNeedsBuild());
  }

  @override
  Widget build(BuildContext context) {
    buildOverlay();
    return widget.child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<OverlayEntry?>('overlayEntry', overlayEntry));
  }
}

class CenterAbout extends StatelessWidget {
  const CenterAbout({
    super.key,
    required this.position,
    required this.child,
  });
  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
        left: position.dx,
        top: position.dy,
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
