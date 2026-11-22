import 'dart:io';

import 'package:dashboard_back/dashboard_server.dart';

Future<void> main(List<String> arguments) async {
  const defaultAddress = '127.0.0.1';
  const defaultPort = 8765;

  String readOption(String name, String fallback) {
    final index = arguments.indexOf(name);
    if (index >= 0 && index + 1 < arguments.length) return arguments[index + 1];
    return fallback;
  }

  final root = Directory(readOption('--root', Directory.current.path));
  final progress = Directory(readOption(
    '--progress',
    '${root.path}${Platform.pathSeparator}SCRUM.d${Platform.pathSeparator}progress',
  ));
  final port =
      int.tryParse(readOption('--port', '$defaultPort')) ?? defaultPort;
  final server = DashboardServer(
    root: root,
    progressDirectory: progress,
  );

  await server.start(address: InternetAddress.loopbackIPv4, port: port);
  print('Dashboard server listening on http://$defaultAddress:$port');
}
