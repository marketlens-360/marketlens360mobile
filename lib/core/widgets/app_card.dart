import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';

/// A card surface with consistent border-radius (12 px), optional border, and
/// optional shadow. Wraps its child in a [SmoothHeightContainer] so the card
/// animates height changes automatically.
///
/// Use [AppCard] as the standard container for all elevated/bordered content
/// panels throughout the app — this is the central styling reference point.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.addBorder = true,
    this.elevation = 0,
    this.shadows,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final bool addBorder;
  final double elevation;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor = color ?? c.surfaceContainerLowest;
    final resolvedBorder = addBorder ? (borderColor ?? c.border) : null;

    // Design spec: light mode = subtle shadow; dark mode = no shadow
    final defaultShadows = isDark
        ? <BoxShadow>[]
        : <BoxShadow>[
            const BoxShadow(
              color: Color(0x0A0F172A),  // rgba(15,23,42,0.04)
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
            const BoxShadow(
              color: Color(0x080F172A),  // rgba(15,23,42,0.03)
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ];

    final finalShadows = shadows ??
        (elevation > 0
            ? [
                isDark
                    ? BoxShadow(
                        color: Colors.black.withAlpha(100),
                        offset: Offset(0, elevation),
                        blurRadius: elevation * 2,
                      )
                    : BoxShadow(
                        color: Colors.black.withAlpha(20),
                        offset: Offset(0, elevation),
                        blurRadius: elevation * 2.5,
                        spreadRadius: -elevation * 0.5,
                      )
              ]
            : defaultShadows);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Container(
        clipBehavior: clipBehavior,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.cardRadius,
          color: resolvedColor,
          boxShadow: finalShadows,
          border: resolvedBorder != null
              ? Border.all(color: resolvedBorder, width: 1)
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SmoothHeightContainer(
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ),
    );
  }
}

/// An [AppCard] variant that spans full width with the standard screen
/// horizontal padding removed (for edge-to-edge cards inside padded pages).
class AppCardFull extends StatelessWidget {
  const AppCardFull({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.addBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool addBorder;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      color: color,
      addBorder: addBorder,
      child: child,
    );
  }
}

/// Animates its height whenever the child's intrinsic height changes.
///
/// Wraps [AnimatedSize] so containers with dynamic content (accordions,
/// expandable sections, loading↔content swaps) smoothly resize without
/// explicit height management.
class SmoothHeightContainer extends StatelessWidget {
  const SmoothHeightContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.padding,
    this.color,
    this.decoration,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final EdgeInsets? padding;
  final Color? color;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: curve,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: padding,
        color: decoration == null ? color : null,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

/// A primary action button styled per the MarketLens360 design: full-width,
/// 12 px radius, brand-blue fill, white text.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.primary,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonRadius,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    icon!,
                  ],
                ],
              ),
      ),
    );
  }
}

/// A small badge for risk levels and status labels.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
  });

  final String label;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final fg = color ?? c.primary;
    final bg = backgroundColor ?? c.primaryDim;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: fg.withAlpha(40), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
