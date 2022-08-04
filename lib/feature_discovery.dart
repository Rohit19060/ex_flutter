import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FeatureDiscovery extends StatefulWidget {
  const FeatureDiscovery({super.key, required this.child});
  static String activeStep(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
            _InheritedFeatureDiscovery>() as _InheritedFeatureDiscovery)
        .activeStepId;
  }

  static void discoverFeatures(BuildContext context, List<String> steps) {
    final _FeatureDiscoveryState state =
        context.findAncestorStateOfType<_FeatureDiscoveryState>()
            as _FeatureDiscoveryState;

    state.discoverFeatures(steps);
  }

  static void markStepComplete(BuildContext context, String stepId) {
    final _FeatureDiscoveryState state =
        context.findAncestorStateOfType<_FeatureDiscoveryState>()
            as _FeatureDiscoveryState;

    state.markStepComplete(stepId);
  }

  static void dismiss(BuildContext context) {
    final _FeatureDiscoveryState state =
        context.findAncestorStateOfType<_FeatureDiscoveryState>()
            as _FeatureDiscoveryState;

    state.dismiss();
  }

  final Widget child;

  @override
  State<FeatureDiscovery> createState() => _FeatureDiscoveryState();
}

class _FeatureDiscoveryState extends State<FeatureDiscovery> {
  List<String>? steps;
  int? activeStepIndex;

  void discoverFeatures(List<String> steps) {
    setState(() {
      this.steps = steps;
      activeStepIndex = 0;
    });
  }

  void markStepComplete(String stepId) {
    if (steps != null && steps![activeStepIndex ?? 0] == stepId) {
      setState(() {
        if (activeStepIndex != null) {
          activeStepIndex = activeStepIndex! + 1;
        }
        if (activeStepIndex! >= steps!.length) {
          _cleanupAfterSteps();
        }
      });
    }
  }

  void dismiss() {
    setState(_cleanupAfterSteps);
  }

  void _cleanupAfterSteps() {
    steps = null;
    activeStepIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFeatureDiscovery(
      activeStepId: steps?.elementAt(activeStepIndex ?? steps!.length) ?? '',
      child: widget.child,
    );
  }
}

class _InheritedFeatureDiscovery extends InheritedWidget {
  const _InheritedFeatureDiscovery({
    required this.activeStepId,
    required super.child,
  });
  final String activeStepId;

  @override
  bool updateShouldNotify(_InheritedFeatureDiscovery oldWidget) {
    return oldWidget.activeStepId != activeStepId;
  }
}

class DescribeFeatureOverlay extends StatefulWidget {
  const DescribeFeatureOverlay(
      {super.key,
      required this.featureId,
      required this.icon,
      required this.color,
      required this.title,
      required this.description,
      required this.child});
  final String featureId;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final Widget child;

  @override
  State<DescribeFeatureOverlay> createState() =>
      _DescriberFeatureOverlayState();
}

enum DescribedFeatureContentOrientation { above, below }

class _DescriberFeatureOverlayState extends State<DescribeFeatureOverlay> {
  Size screenSize = Size.zero;
  bool showOverlay = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    showOverlayIfActiveStep();
  }

  void showOverlayIfActiveStep() {
    final String activeStep = FeatureDiscovery.activeStep(context);
    setState(() => showOverlay = activeStep == widget.featureId);
  }

  bool isCloseToTheTopOrBottom(Offset position) {
    return position.dy <= 88.0 || (screenSize.height - position.dy) <= 88.0;
  }

  bool isOnTopHalfOfScreen(Offset position) {
    return position.dy < (screenSize.height / 2.0);
  }

  bool isOnLeftHalfOfScreen(Offset position) {
    return position.dx < (screenSize.width / 2.0);
  }

  DescribedFeatureContentOrientation getContentOrientation(Offset position) {
    if (isCloseToTheTopOrBottom(position)) {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.below;
      } else {
        return DescribedFeatureContentOrientation.above;
      }
    } else {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.above;
      } else {
        return DescribedFeatureContentOrientation.below;
      }
    }
  }

  @override
  void activate() {
    super.activate();
    FeatureDiscovery.markStepComplete(context, widget.featureId);
  }

  void dismiss() {
    FeatureDiscovery.dismiss(context);
  }

  Widget buildOverlay(Offset anchor) {
    return Stack(
      children: [
        GestureDetector(
          onTap: dismiss,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Background(
          anchor: anchor,
          color: widget.color,
          screenSize: screenSize,
        ),
        _Content(
          anchor: anchor,
          screenSize: screenSize,
          title: widget.title,
          description: widget.description,
          touchTargetRadius: 44.0,
          touchTargetToContentPadding: 20.0,
        ),
        TouchTarget(
          anchor: anchor,
          icon: widget.icon,
          color: widget.color,
          onPressed: activate,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: showOverlay,
      overlayBuilder: (BuildContext context, Offset anchor) {
        return buildOverlay(anchor);
      },
      child: widget.child,
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.anchor,
    required this.color,
    required this.screenSize,
  });
  final Offset anchor;
  final Color color;
  final Size screenSize;

  bool isCloseToTheTopOrBottom(Offset position) {
    return position.dy <= 88.0 || (screenSize.height - position.dy) <= 88.0;
  }

  bool isOnTopHalfOfScreen(Offset position) {
    return position.dy < (screenSize.height / 2.0);
  }

  bool isOnLeftHalfOfScreen(Offset position) {
    return position.dx < (screenSize.width / 2.0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isBackgroundCentered = isCloseToTheTopOrBottom(anchor);
    final double backgroundRadius =
        screenSize.width * (isBackgroundCentered ? 1.0 : 0.75);
    final Offset backgroundPosition = isBackgroundCentered
        ? anchor
        : Offset(
            screenSize.width / 2.0 +
                (isOnLeftHalfOfScreen(anchor) ? -20.0 : 20.0),
            anchor.dy +
                (isOnTopHalfOfScreen(anchor)
                    ? -(screenSize.width / 2.0)
                    : (screenSize.width / 2.0)));
    return CenterAbout(
      position: backgroundPosition,
      child: Container(
        width: 2 * backgroundRadius,
        height: 2 * backgroundRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.96),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.anchor,
    required this.screenSize,
    required this.title,
    required this.description,
    required this.touchTargetRadius,
    required this.touchTargetToContentPadding,
  });
  final Offset anchor;
  final Size screenSize;
  final String title;
  final String description;
  final double touchTargetRadius;
  final double touchTargetToContentPadding;

  bool isCloseToTheTopOrBottom(Offset position) {
    return position.dy <= 88.0 || (screenSize.height - position.dy) <= 88.0;
  }

  bool isOnTopHalfOfScreen(Offset position) {
    return position.dy < (screenSize.height / 2.0);
  }

  bool isOnLeftHalfOfScreen(Offset position) {
    return position.dx < (screenSize.width / 2.0);
  }

  DescribedFeatureContentOrientation getContentOrientation(Offset position) {
    if (isCloseToTheTopOrBottom(position)) {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.below;
      } else {
        return DescribedFeatureContentOrientation.above;
      }
    } else {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.above;
      } else {
        return DescribedFeatureContentOrientation.below;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DescribedFeatureContentOrientation contentOrientation =
        getContentOrientation(anchor);
    final double contentOffsetMultiplier =
        contentOrientation == DescribedFeatureContentOrientation.below
            ? 1.0
            : -1.0;
    final double contentY =
        anchor.dy + (contentOffsetMultiplier * (touchTargetRadius + 20.0));
    final double contentFractionalOffset =
        contentOffsetMultiplier.clamp(-1.0, 0.0);

    return Positioned(
      top: contentY,
      child: FractionalTranslation(
        translation: Offset(0.0, contentFractionalOffset),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TouchTarget extends StatelessWidget {
  const TouchTarget({
    super.key,
    required this.anchor,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  final Offset anchor;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const double touchTargetRadius = 44.0;

    return CenterAbout(
      position: anchor,
      child: SizedBox(
        width: 2 * touchTargetRadius,
        height: 2 * touchTargetRadius,
        child: RawMaterialButton(
          shape: const CircleBorder(),
          fillColor: Colors.white,
          onPressed: onPressed,
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OverlayBuilder(
        showOverlay: showOverlay,
        overlayBuilder: (BuildContext overlayContext) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset center =
              box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));

          return overlayBuilder(overlayContext, center);
        },
        child: child,
      );
    });
  }
}

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder(
      {super.key,
      this.showOverlay = false,
      required this.overlayBuilder,
      required this.child});
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  @override
  State<OverlayBuilder> createState() => _OverlayBuilderState();
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
      Overlay.of(context)?.insert(entry);
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
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  const CenterAbout({super.key, required this.position, required this.child});
  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}

void main() => runApp(const MyApp());

const String feature1 = 'FEATURE_1';
const String feature2 = 'FEATURE_2';
const String feature3 = 'FEATURE_3';
const String feature4 = 'FEATURE_4';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Discovery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: DescribeFeatureOverlay(
            featureId: feature1,
            icon: Icons.menu,
            color: Colors.red,
            title: 'The Title',
            description: 'The Description',
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          title: const Text(''),
          actions: [
            DescribeFeatureOverlay(
              featureId: feature2,
              icon: Icons.search,
              color: Colors.red,
              title: 'Search in here',
              description: 'The Description',
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: const Content(),
        floatingActionButton: DescribeFeatureOverlay(
          featureId: feature3,
          icon: Icons.add,
          color: Colors.red,
          title: 'Fab in here',
          description: 'The Description',
          child: FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/images/pic.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Starbucks Kyoto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Text(
                    'Coffee Shop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text('Do Feature Discovery :D'),
                onPressed: () {
                  FeatureDiscovery.discoverFeatures(
                      context, [feature1, feature2, feature3, feature4]);
                },
              ),
            ),
          ],
        ),
        Positioned(
          top: 200.0,
          right: 0.0,
          child: FractionalTranslation(
            translation: const Offset(-0.5, -0.5),
            child: DescribeFeatureOverlay(
              featureId: feature4,
              icon: Icons.drive_eta,
              color: Colors.red,
              title: 'Fab in here',
              description: 'The Description',
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                child: const Icon(Icons.drive_eta),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
