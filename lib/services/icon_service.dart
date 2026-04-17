import 'package:flutter_lucide/flutter_lucide.dart';

abstract final class IconService {
  // ── Bottom Navigation ────────────────────────────────────────────────────────
  static const home      = LucideIcons.home;
  static const stocks    = LucideIcons.trending_up;
  static const funds     = LucideIcons.landmark;
  static const aiChat    = LucideIcons.bot;

  // ── Drawer Navigation ────────────────────────────────────────────────────────
  static const marketOverview = LucideIcons.layout_dashboard;
  static const watchlist      = LucideIcons.eye;
  static const education      = LucideIcons.graduation_cap;
  static const settings       = LucideIcons.settings;
  static const help           = LucideIcons.help_circle;
  static const profile        = LucideIcons.circle_user;
  static const notifications  = LucideIcons.bell;

  // ── Common UI ────────────────────────────────────────────────────────────────
  static const search      = LucideIcons.search;
  static const bell        = LucideIcons.bell;
  static const bellPlus    = LucideIcons.bell_plus;
  static const eye         = LucideIcons.eye;
  static const eyeOff      = LucideIcons.eye_off;
  static const chevronDown = LucideIcons.chevron_down;
  static const chevronRight = LucideIcons.chevron_right;
  static const arrowRight  = LucideIcons.arrow_right;
  static const add         = LucideIcons.plus;
  static const compare     = LucideIcons.git_compare;
  static const analytics   = LucideIcons.bar_chart_2;
  static const attach      = LucideIcons.paperclip;
  static const send        = LucideIcons.send;
  static const menu        = LucideIcons.menu;
  static const close       = LucideIcons.x;

  // ── Status / Feedback ────────────────────────────────────────────────────────
  static const error  = LucideIcons.x_circle;
  static const inbox  = LucideIcons.inbox;
  static const check  = LucideIcons.check_circle_2;

  // ── Actions ──────────────────────────────────────────────────────────────────
  static const delete    = LucideIcons.trash_2;
  static const arrowUp   = LucideIcons.arrow_up;
  static const arrowDown = LucideIcons.arrow_down;
  static const back      = LucideIcons.arrow_left;

  // ── Legacy aliases (kept for backwards compat with existing widgets) ──────────
  static const markets = LucideIcons.trending_up;
}
