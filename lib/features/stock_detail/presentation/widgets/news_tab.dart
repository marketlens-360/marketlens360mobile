import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/widgets/app_empty_view.dart';

// Placeholder — news API integration in Phase 2
class NewsTab extends StatelessWidget {
  const NewsTab({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return const AppEmptyView(
      message: 'News coming soon',
      subMessage: 'Market news integration is planned for Phase 2.',
    );
  }
}
