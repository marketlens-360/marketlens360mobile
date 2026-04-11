import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_spacing.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base      = isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB);
    final highlight = isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => Divider(color: AppColors.of(context).border, height: 1),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.listItemV + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 13, width: 52, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Container(height: 11, width: 120, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(height: 13, width: 56, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(
                    height: 22,
                    width: 52,
                    decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(AppSpacing.radiusPill)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Compact shimmer for a single row (used inside cards)
class ShimmerRow extends StatelessWidget {
  const ShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final base      = isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB);
    final highlight = isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 10),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 13, width: 52, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 5),
                    Container(height: 11, width: 100, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(height: 13, width: 56, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 5),
                    Container(height: 22, width: 52, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(AppSpacing.radiusPill))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
