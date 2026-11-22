import 'package:flutter/material.dart';

import 'dashboard/dashboard_shell.dart';
import 'data/dashboard_data_interface.dart';
import 'data/dashboard_http_interface.dart';
import 'theme/dashboard_tokens.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({
    super.key,
    this.data,
  });

  final DashboardDataInterface? data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalendarStream Scrum Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: DashboardShell(
        data: data ?? HttpDashboardDataInterface(),
      ),
    );
  }

  static ThemeData _theme(Brightness brightness) {
    final tokens =
        brightness == Brightness.dark ? DashboardTokens.dark : DashboardTokens.light;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.accent,
      onPrimary: tokens.onAccent,
      secondary: tokens.accent,
      onSecondary: tokens.onAccent,
      error: tokens.bad,
      onError: tokens.badBg,
      surface: tokens.card,
      onSurface: tokens.text,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.bg,
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}
