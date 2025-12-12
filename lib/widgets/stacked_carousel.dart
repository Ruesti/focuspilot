import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;


class StackedCarouselItem {
  final String id;
  final Widget card;
  final Widget fullScreen;

  const StackedCarouselItem({
    required this.id,
    required this.card,
    required this.fullScreen,
  });
}

class StackedCardCarousel extends StatefulWidget {
  final List<StackedCarouselItem> items;

  final double height;

  /// Horizontal overlap (px per card-distance). Higher => more overlap (cards closer).
  final double overlapX;

  /// Vertical depth offset per distance step.
  final double depthY;

  /// Scale/opacity for side/far.
  final double sideScale;
  final double farScale;
  final double sideOpacity;
  final double farOpacity;

  /// How many neighbors to show on each side.
  final int neighbors;

  /// Fullscreen max width.
  final double fullScreenMaxWidth;

  /// Drag sensitivity: px needed to move by 1 card (bigger = softer).
  final double dragPixelsPerCard;

  /// Commit threshold (in cards) before snapping to next/prev on release.
  final double commitThresholdCards;

  /// Fling velocity to force commit.
  final double flingVelocity;

  /// Drag up to open fullscreen (px).
  final double openFullscreenDragUpPx;

  const StackedCardCarousel({
    super.key,
    required this.items,
    this.height = 520,
    this.overlapX = 92,
    this.depthY = 14,
    this.sideScale = 0.93,
    this.farScale = 0.86,
    this.sideOpacity = 0.92,
    this.farOpacity = 0.62,
    this.neighbors = 2,
    this.fullScreenMaxWidth = 1400,
    this.dragPixelsPerCard = 340,
    this.commitThresholdCards = 0.34,
    this.flingVelocity = 950,
    this.openFullscreenDragUpPx = 90,
  });

  @override
  State<StackedCardCarousel> createState() => _StackedCardCarouselState();
}

enum _PanMode { none, horizontal, vertical }

class _StackedCardCarouselState extends State<StackedCardCarousel>
    with SingleTickerProviderStateMixin {
  double _pos = 0.0;

  _PanMode _mode = _PanMode.none;
  double _accDx = 0.0;
  double _accDy = 0.0;

  late final AnimationController _snap;
  Animation<double>? _snapAnim;

  @override
  void initState() {
    super.initState();
    _snap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() {
        final a = _snapAnim;
        if (a == null) return;
        setState(() => _pos = a.value);
      });
  }

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    final maxPos = (items.length - 1).toDouble();
    _pos = _pos.clamp(0.0, maxPos);

    // base/next define the transition pair.
    final base = _pos.floor().clamp(0, items.length - 1);
    final next = (base + 1).clamp(0, items.length - 1);
    final frac = (_pos - base).clamp(0.0, 1.0);

    final s = Curves.easeInOutCubic.transform(frac);

// Plateau: aktive Karte bleibt länger dominant
final plateau =
    1.0 - math.pow((2 * s - 1).abs(), 1.8).toDouble(); // 0..1


    final start = math.max(0, base - widget.neighbors);
    final end = math.min(items.length - 1, next + widget.neighbors);

    // Build render cards (no z sorting! we render in a fixed stable order)
    final cards = <_RenderCard>[];
    for (int i = start; i <= end; i++) {
      final d = i - _pos; // <0 left, >0 right
      final ad = d.abs();
      final t = (ad / math.max(1, widget.neighbors)).clamp(0.0, 1.0);

      // base position/scale/opacity by distance
      double x = d * widget.overlapX;
      double y = ad * widget.depthY;

      // base distance look
double scale =
    _lerp(1.0, _lerp(widget.sideScale, widget.farScale, t), t);
double opacity =
    _lerp(1.0, _lerp(widget.sideOpacity, widget.farOpacity, t), t);

// ✅ smooth handoff for the transition pair (no sudden opacity jump)
if (i == base || i == next) {
  // 0..1 with easing
  final s = Curves.easeInOutCubic.transform(frac);

  // base weight goes 1->0, next goes 0->1
  final w = (i == base)
    ? (1.0 - s + 0.18 * plateau).clamp(0.0, 1.0)
    : (s + 0.30 * plateau).clamp(0.0, 1.0);


  // We want BOTH cards always visible, but base dominant early, next dominant late.
  // Use a controlled range, not multiplicative stacking.
  final targetOpacity = 0.5 + 0.5 * w; // 0.55..1.0
  final targetScale = 0.94 + 0.06 * w;   // 0.94..1.0
  final targetDepth = 1.0 - w;           // 1..0 (small push back when not dominant)

  opacity = lerpDouble(opacity, targetOpacity, 0.65)!;
scale   = lerpDouble(scale,   targetScale,   0.85)!;

if (i == base) {
  scale += 0.02 * plateau; // 2% in der Mitte
}


  y += targetDepth * 2.0;
}


      cards.add(_RenderCard(
        index: i,
        x: x,
        y: y,
        scale: scale,
        opacity: opacity,
      ));
    }

    // Stable render list:
    // - far/back cards first (farthest first)
    // - then next
    // - then base ALWAYS LAST (always on top) => no layer flip
    final back = cards
        .where((c) => c.index != base && c.index != next)
        .toList()
      ..sort((a, b) {
        final da = (a.index - _pos).abs();
        final db = (b.index - _pos).abs();
        return db.compareTo(da); // far -> near
      });

    final rcNext = cards.where((c) => c.index == next).toList();
    final rcBase = cards.where((c) => c.index == base).toList();

    final renderList = <_RenderCard>[
      ...back,
      ...rcNext,
      ...rcBase,
    ];

    // Allow interaction on the top card only.
    // Keep this based on frac but DO NOT affect drawing order.
    final activeIndex = (frac < 0.5) ? base : next;

    return SizedBox(
      height: widget.height,
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          PanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            () => PanGestureRecognizer(),
            (PanGestureRecognizer g) {
              g.onStart = (_) {
                _snap.stop();
                _snapAnim = null;
                _mode = _PanMode.none;
                _accDx = 0;
                _accDy = 0;
              };

              g.onUpdate = (details) {
                if (_mode == _PanMode.none) {
                  _accDx += details.delta.dx;
                  _accDy += details.delta.dy;

                  const slop = 10.0;
                  if (_accDx.abs() < slop && _accDy.abs() < slop) return;

                  if (_accDx.abs() > _accDy.abs() * 1.35) {
                    _mode = _PanMode.horizontal;
                  } else if (_accDy.abs() > _accDx.abs() * 1.35) {
                    _mode = _PanMode.vertical;
                  } else {
                    return;
                  }
                }

                if (_mode == _PanMode.horizontal) {
                  final deltaCards =
                      details.delta.dx / widget.dragPixelsPerCard;
                  setState(() {
                    _pos = (_pos - deltaCards).clamp(0.0, maxPos);
                  });
                } else if (_mode == _PanMode.vertical) {
                  _accDy += details.delta.dy;
                  if (_accDy <= -widget.openFullscreenDragUpPx) {
                    _mode = _PanMode.none;
                    _accDx = 0;
                    _accDy = 0;
                    _openFullscreen(context, items[activeIndex]);
                  }
                }
              };

              g.onEnd = (details) {
                if (_mode == _PanMode.horizontal) {
                  _snapToTarget(details.velocity.pixelsPerSecond.dx);
                }
                _mode = _PanMode.none;
                _accDx = 0;
                _accDy = 0;
              };

              g.onCancel = () {
                if (_mode == _PanMode.horizontal) _snapToTarget(0);
                _mode = _PanMode.none;
                _accDx = 0;
                _accDy = 0;
              };
            },
          ),
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // glow behind
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.25),
                      radius: 1.2,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ...renderList.map((rc) {
              final item = items[rc.index];
              final isTopInteractive = rc.index == activeIndex;

              return Positioned(
                child: Transform.translate(
                  offset: Offset(rc.x, rc.y),
                  child: Transform.scale(
                    scale: rc.scale,
                    child: Opacity(
                      opacity: rc.opacity,
                      child: IgnorePointer(
                        ignoring: !isTopInteractive,
                        child: _ClayCardShell(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),

                              // kill desktop hover/pressed overlays
                              overlayColor: MaterialStateProperty.all(
                                Colors.transparent,
                              ),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,

                              onTap: () => _openFullscreen(context, item),
                              child: Hero(
                                tag: 'stacked_${item.id}',
                                child: item.card,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            Positioned(
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.75),
                  ),
                ),
                child: Text(
                  "ziehen links/rechts · hochziehen · klicken",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snapToTarget(double vx) {
    final items = widget.items;
    if (items.isEmpty) return;

    final maxPos = (items.length - 1).toDouble();
    _pos = _pos.clamp(0.0, maxPos);

    final current = _pos;
    final base = current.roundToDouble();
    final delta = current - base;

    double target = base;

    if (vx.abs() > widget.flingVelocity) {
      target = (vx < 0) ? current.ceilToDouble() : current.floorToDouble();
    } else {
      if (delta.abs() >= widget.commitThresholdCards) {
        target =
            (delta > 0) ? current.ceilToDouble() : current.floorToDouble();
      } else {
        target = base;
      }
    }

    target = target.clamp(0.0, maxPos);

    _snap.stop();
    _snap.reset();
    _snapAnim = Tween<double>(begin: _pos, end: target).animate(
      CurvedAnimation(parent: _snap, curve: Curves.easeOutCubic),
    );
    _snap.forward();
  }

  void _openFullscreen(BuildContext context, StackedCarouselItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.12),
        pageBuilder: (_, __, ___) => _FullscreenDismissSheet(
          heroTag: 'stacked_${item.id}',
          maxWidth: widget.fullScreenMaxWidth,
          child: item.fullScreen,
        ),
        transitionsBuilder: (_, anim, __, child) {
          final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return FadeTransition(opacity: c, child: child);
        },
      ),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class _RenderCard {
  final int index;
  final double x;
  final double y;
  final double scale;
  final double opacity;

  _RenderCard({
    required this.index,
    required this.x,
    required this.y,
    required this.scale,
    required this.opacity,
  });
}

class _ClayCardShell extends StatelessWidget {
  final Widget child;
  const _ClayCardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 980),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: cs.surface.withOpacity(0.94),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: child,
      ),
    );
  }
}

/// Fullscreen wrapper that dismisses by dragging down AND transitions (scale/opacity/radius/backdrop).
class _FullscreenDismissSheet extends StatefulWidget {
  final String heroTag;
  final Widget child;
  final double maxWidth;

  const _FullscreenDismissSheet({
    required this.heroTag,
    required this.child,
    required this.maxWidth,
  });

  @override
  State<_FullscreenDismissSheet> createState() => _FullscreenDismissSheetState();
}

class _FullscreenDismissSheetState extends State<_FullscreenDismissSheet>
    with SingleTickerProviderStateMixin {
  double _dy = 0.0;

  late final AnimationController _back;
  Animation<double>? _backAnim;

  @override
  void initState() {
    super.initState();
    _back = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        final a = _backAnim;
        if (a == null) return;
        setState(() => _dy = a.value);
      });
  }

  @override
  void dispose() {
    _back.dispose();
    super.dispose();
  }

  void _animateBack() {
    _back.stop();
    _back.reset();
    _backAnim = Tween<double>(begin: _dy, end: 0.0).animate(
      CurvedAnimation(parent: _back, curve: Curves.easeOutCubic),
    );
    _back.forward();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final p = (_dy / 320.0).clamp(0.0, 1.0);
    final scale = 1.0 - (0.10 * p);
    final cardOpacity = 1.0 - (0.35 * p);
    final backdropOpacity = 1.0 - p;
    final radius = 28.0 + (18.0 * p);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: backdropOpacity,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: Offset(0, _dy),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: cardOpacity,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: widget.maxWidth),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragUpdate: (d) {
                          if (d.delta.dy > 0) {
                            setState(() {
                              _dy = (_dy + d.delta.dy).clamp(0.0, 520.0);
                            });
                          }
                        },
                        onVerticalDragEnd: (d) {
                          final v = d.primaryVelocity ?? 0.0;
                          if (_dy > 140 || v > 1100) {
                            Navigator.of(context).pop();
                          } else {
                            _animateBack();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            color: cs.surface.withOpacity(0.98),
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(0.82),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 46,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Stack(
                              children: [
                                Hero(tag: widget.heroTag, child: widget.child),
                                Positioned(
                                  top: 8,
                                  left: 0,
                                  right: 0,
                                  child: IgnorePointer(
                                    child: Center(
                                      child: Container(
                                        width: 58,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: cs.outlineVariant.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
