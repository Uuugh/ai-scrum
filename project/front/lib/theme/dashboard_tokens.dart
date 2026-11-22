import 'package:flutter/material.dart';

class DashboardTokens extends ThemeExtension<DashboardTokens> {
  const DashboardTokens({
    required this.bg,
    required this.card,
    required this.soft,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.warn,
    required this.warnBg,
    required this.bad,
    required this.badBg,
  });

  final Color bg;
  final Color card;
  final Color soft;
  final Color line;
  final Color text;
  final Color muted;
  final Color accent;
  final Color onAccent;
  final Color warn;
  final Color warnBg;
  final Color bad;
  final Color badBg;

  static const light = DashboardTokens(
    bg: Color(0xFFF7F6F3),
    card: Color(0xFFFDFCFA),
    soft: Color(0xFFF1EFEB),
    line: Color(0xFFE8E4DE),
    text: Color(0xFF2B2F36),
    muted: Color(0xFF626C7C),
    accent: Color(0xFF40609C),
    onAccent: Color(0xFFFFFFFF),
    warn: Color(0xFF946A24),
    warnBg: Color(0xFFFAF3E6),
    bad: Color(0xFFB4483C),
    badBg: Color(0xFFFAEEEB),
  );

  static const dark = DashboardTokens(
    bg: Color(0xFF0F1218),
    card: Color(0xFF171B23),
    soft: Color(0xFF1D222C),
    line: Color(0xFF2A303B),
    text: Color(0xFFE6E8EC),
    muted: Color(0xFF98A2B3),
    accent: Color(0xFF93B4FF),
    onAccent: Color(0xFF0F1218),
    warn: Color(0xFFFBBF24),
    warnBg: Color(0xFF2B2110),
    bad: Color(0xFFF87171),
    badBg: Color(0xFF2D1414),
  );

  @override
  DashboardTokens copyWith({Color? bg}) => DashboardTokens(
        bg: bg ?? this.bg,
        card: card,
        soft: soft,
        line: line,
        text: text,
        muted: muted,
        accent: accent,
        onAccent: onAccent,
        warn: warn,
        warnBg: warnBg,
        bad: bad,
        badBg: badBg,
      );

  @override
  DashboardTokens lerp(ThemeExtension<DashboardTokens>? other, double t) =>
      other is DashboardTokens ? other : this;
}
