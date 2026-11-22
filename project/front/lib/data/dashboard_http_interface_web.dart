import 'dart:convert';
// ignore: deprecated_member_use
import 'dart:html';

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
      return DashboardSnapshot(serverError: sprint.error);
    }
    return DashboardSnapshot(
      sprintError: sprint.error,
      requirementsError: requirements.error,
      issueError: issues.error,
      progressError: progress.error,
    );
  }

  Future<_HttpResult> _get(String path) async {
    try {
      final response = await HttpRequest.request(
        '$baseUri$path',
        method: 'GET',
        requestHeaders: const {'Accept': 'application/json'},
        withCredentials: false,
      );
      json.decode(response.responseText ?? '{}');
      return const _HttpResult.ok();
    } catch (error) {
      return _HttpResult.error(error.toString());
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
