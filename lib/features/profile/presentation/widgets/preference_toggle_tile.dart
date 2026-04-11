import 'package:flutter/material.dart';
import 'package:marketlens360mobile/core/theme/app_colors.dart';
import 'package:marketlens360mobile/core/theme/app_text_styles.dart';

class PreferenceToggleTile extends StatelessWidget {
  const PreferenceToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.labelMd),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.labelSm)
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.accent,
    );
  }
}
