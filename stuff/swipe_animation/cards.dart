import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'feature_discovery.dart';
import 'matches.dart';
import 'photos.dart';
import 'profiles.dart';

class CardStack extends StatefulWidget {
  const CardStack({
    super.key,
    required this.matchEngine,
  });
  final MatchEngine matchEngine;

  @override
  CardStackState createState() => CardStackState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<MatchEngine>('matchEngine', matchEngine));
  }
}

class CardStackState extends State<CardStack> {
  Key? _frontCard;
  DateMatch? _currentMatch;
  double _nextCardScale = 0.9;

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);
    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch!.addListener(_onMatchChange);
    _frontCard = Key(_currentMatch!.profile.name);
  }

  @override
  void dispose() {
    super.dispose();
    if (_currentMatch != null) {
      _currentMatch!.removeListener(_onMatchChange);
    }
    widget.matchEngine.removeListener(_onMatchEngineChange);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
      if (_currentMatch != null) {
        _currentMatch!.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch!.addListener(_onMatchChange);
      }
    }
  }

  void _onMatchEngineChange() {
    setState(() {
      if (_currentMatch != null) {
        _currentMatch!.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch!.addListener(_onMatchChange);
      }
      _frontCard = Key(_currentMatch!.profile.name);
    });
  }

  void _onMatchChange() {
    setState(() {});
  }

  Widget _buildBackCard() => Transform(
        transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
        alignment: Alignment.center,
        child: ProfileCard(profile: widget.matchEngine.nextMatch.profile),
      );

  Widget _buildFrontCard() => ProfileCard(
        key: _frontCard,
        profile: widget.matchEngine.currentMatch.profile,
      );

  SlideDirection? _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    final currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        break;
      case SlideDirection.right:
        currentMatch.like();
        break;
      case SlideDirection.up:
        currentMatch.superLike();
        break;
      default:
        break;
    }
    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          DraggableCard(card: _buildBackCard(), isDraggable: false),
          DraggableCard(
              card: _buildFrontCard(),
              slideTo: _desiredSlideOutDirection(),
              onSlideUpdate: _onSlideUpdate,
              onSlideOutComplete: _onSlideOutComplete),
        ],
      );
}

enum SlideDirection { left, right, up }

class DraggableCard extends StatefulWidget {
  const DraggableCard({
    super.key,
    required this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideOutComplete,
  });
  final Widget card;
  final bool isDraggable;
  final SlideDirection? slideTo;
  final Function(double distance)? onSlideUpdate;
  final Function(SlideDirection direction)? onSlideOutComplete;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Function(SlideDirection direction)?>.has(
        'onSlideOutComplete', onSlideOutComplete));
    properties.add(ObjectFlagProperty<Function(double distance)?>.has(
        'onSlideUpdate', onSlideUpdate));
    properties.add(EnumProperty<SlideDirection?>('slideTo', slideTo));
    properties.add(DiagnosticsProperty<bool>('isDraggable', isDraggable));
  }
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision? decision;
  final GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset? cardOffset = Offset.zero;
  Offset? dragStart;
  Offset? dragPosition;
  Offset? dragBackStart;
  Offset? slideBackStart;
  SlideDirection? slideOutDirection;
  late AnimationController slideBackAnimation;
  Tween<Offset>? slideOutTween;
  late AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              Offset.zero,
              Curves.elasticOut.transform(slideBackAnimation.value),
            );
            if (widget.onSlideUpdate != null) {
              widget.onSlideUpdate!(cardOffset!.distance);
            }
          }))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(
        () => setState(() {
          cardOffset = slideOutTween!.evaluate(slideOutAnimation);
          if (widget.onSlideUpdate != null) {
            widget.onSlideUpdate!(cardOffset!.distance);
          }
        }),
      )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;
            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete!(
                  slideOutDirection ?? SlideDirection.left);
            }
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = Offset.zero;
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
        default:
          break;
      }
    }
  }

  Future<Offset> _chooseRandomDragStart() async {
    final ctx = MediaQuery.of(context);
    final cardTopLeft =
        (profileCardKey.currentContext!.findRenderObject()! as RenderBox)
            .localToGlobal(Offset.zero);
    final dragStartY = ctx.size.height * 0.25 + cardTopLeft.dy;
    return Offset(ctx.size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  Future<void> _slideLeft() async {
    dragStart = await _chooseRandomDragStart();
    if (mounted) {
      slideOutTween =
          Tween(begin: Offset.zero, end: Offset(-2 * context.size!.width, 0));
    }
    await slideOutAnimation.forward(from: 0);
  }

  Future<void> _slideRight() async {
    dragStart = await _chooseRandomDragStart();
    if (mounted) {
      slideOutTween =
          Tween(begin: Offset.zero, end: Offset(2 * context.size!.width, 0));
    }
    await slideOutAnimation.forward(from: 0);
  }

  Future<void> _slideUp() async {
    dragStart = await _chooseRandomDragStart();
    if (mounted) {
      slideOutTween =
          Tween(begin: Offset.zero, end: Offset(0, -2 * context.size!.height));
    }
    await slideOutAnimation.forward(from: 0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition! - dragStart!;
      if (widget.onSlideUpdate != null) {
        widget.onSlideUpdate!(cardOffset!.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset! / cardOffset!.distance;
    final isInLeftRegion = (cardOffset!.dx / context.size!.width) < -0.45;
    final isInRightRegion = (cardOffset!.dx / context.size!.width) > 0.45;
    final isInTopRegion = (cardOffset!.dy / context.size!.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size!.width));
        slideOutAnimation.forward(from: 0);
        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size!.height));
        slideOutAnimation.forward(from: 0);
        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart!.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (math.pi / 8) *
          (cardOffset!.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart! - dragBounds.topLeft;
    } else {
      return Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) => AnchoredOverlay(
        showOverlay: true,
        child: const Center(),
        overlayBuilder: (context, anchorBounds, anchor) => CenterAbout(
          position: anchor,
          child: Transform(
            transform:
                Matrix4.translationValues(cardOffset!.dx, cardOffset!.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: widget.card),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>(
        'slideOutAnimation', slideOutAnimation));
    properties.add(
        DiagnosticsProperty<Tween<Offset>?>('slideOutTween', slideOutTween));
    properties.add(DiagnosticsProperty<AnimationController>(
        'slideBackAnimation', slideBackAnimation));
    properties.add(
        EnumProperty<SlideDirection?>('slideOutDirection', slideOutDirection));
    properties
        .add(DiagnosticsProperty<Offset?>('slideBackStart', slideBackStart));
    properties
        .add(DiagnosticsProperty<Offset?>('dragBackStart', dragBackStart));
    properties.add(DiagnosticsProperty<Offset?>('dragPosition', dragPosition));
    properties.add(DiagnosticsProperty<Offset?>('dragStart', dragStart));
    properties.add(DiagnosticsProperty<Offset?>('cardOffset', cardOffset));
    properties.add(DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>(
        'profileCardKey', profileCardKey));
    properties.add(EnumProperty<Decision?>('decision', decision));
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key, required this.profile});
  final Profile profile;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Profile>('profile', profile));
  }
}

class _ProfileCardState extends State<ProfileCard> {
  Widget _buildBackground() => PhotoBrowser(
      photoAssetPaths: widget.profile.photos, visiblePhotoIndex: 0);

  Widget _buildProfileSynopsis() => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Text(widget.profile.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      Text(widget.profile.bio,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18))
                    ])),
                const Icon(Icons.info, color: Colors.white)
              ],
            )),
      );

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x11000000), blurRadius: 5, spreadRadius: 2)
            ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
                child: Stack(
                    fit: StackFit.expand,
                    children: [_buildBackground(), _buildProfileSynopsis()]))),
      );
}
