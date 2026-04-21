import 'package:flutter/material.dart';

// ── Initials avatar (always white, for gradient header) ──────────────────────
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
