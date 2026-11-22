import 'dart:convert';
import 'dart:io';

import 'dashboard_data_interface.dart';

class HttpDashboardDataInterface implements DashboardDataInterface {
  HttpDashboardDataInterface({this.baseUri = 'http://127.0.0.1:8765'});

  final String baseUri;

  @override
  Future<DashboardSnapshot> reload() async {
    final sprint = await _get('/sprint');
    final requirements = await _get('/requirements');
    final issues = await _get('/issues');
    final progress = await _get('/progress');
    await _get('/usage');
    if (!sprint.ok) {
      return DashboardSnapshot(
        serverError: sprint.error,
      );
    }
    return DashboardSnapshot(
      requirementsError: requirements.error,
      issueError: issues.error,
      progressError: progress.error,
    );
  }

  Future<_HttpResult> _get(String path) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$baseUri$path');
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = await response.transform(utf8.decoder).join();
        json.decode(body);
        return const _HttpResult.ok();
      }
      final reason = await response.transform(utf8.decoder).join();
      return _HttpResult.error(reason);
    } catch (error) {
      return _HttpResult.error(error.toString());
    } finally {
      client.close(force: true);
    }
  }
}

class _HttpResult {
  const _HttpResult.ok()
      : ok = true,
        error = null;

  const _HttpResult.error(this.error) : ok = false;

  final bool ok;
  final String? error;
}
