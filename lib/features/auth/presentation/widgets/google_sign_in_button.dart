import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';
import 'package:marketlens360mobile/features/auth/providers/auth_providers.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          foregroundColor: AppColors.textPrimary,
        ),
        onPressed: isLoading
            ? null
            : () => ref.read(authProvider).signInWithGoogle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const _GoogleLogo(size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              isLoading ? 'Signing in…' : 'Continue with Google',
              style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// A minimal recreation of the Google "G" logo using colored arcs.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2;

    const blue   = Color(0xFF4285F4);
    const red    = Color(0xFFEA4335);
    const yellow = Color(0xFFFBBC05);
    const green  = Color(0xFF34A853);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.22
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72);

    // Blue arc: top-right (~345° → ~90°, going clockwise through 360°/0°)
    strokePaint.color = blue;
    canvas.drawArc(rect, _rad(-15), _rad(105), false, strokePaint);

    // Red arc: top-left (~195° → ~345°)
    strokePaint.color = red;
    canvas.drawArc(rect, _rad(195), _rad(150), false, strokePaint);

    // Yellow arc: bottom-left (~150° → ~195°)
    strokePaint.color = yellow;
    canvas.drawArc(rect, _rad(150), _rad(45), false, strokePaint);

    // Green arc: bottom-right (~90° → ~150°)
    strokePaint.color = green;
    canvas.drawArc(rect, _rad(90), _rad(60), false, strokePaint);

    // White horizontal bar of the "G"
    final barPaint = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;
    final barLeft   = cx;
    final barRight  = cx + r * 0.72;
    final barTop    = cy - size.height * 0.11;
    final barBottom = cy + size.height * 0.11;
    canvas.drawRect(
      Rect.fromLTRB(barLeft, barTop, barRight, barBottom),
      barPaint,
    );
  }

  double _rad(double deg) => deg * 3.1415926535 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
