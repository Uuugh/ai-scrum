import 'dart:convert';
import 'dart:io';

import 'package:dashboard_back/dashboard_server.dart';

class FakeIssueTracker implements IssueTracker {
  final calls = <List<String>>[];
  final utf8Output = 'Review ’ — ›';

  @override
  Future<IssueResult> run(List<String> arguments) async {
    calls.add(List<String>.from(arguments));
    if (arguments.first == 'issue' && arguments[1] == 'list') {
      return IssueResult(
        exitCode: 0,
        stdout: json.encode([
          {
            'number': 42,
            'title': 'Test',
            'labels': [
              {'name': 'backlog'},
            ],
          }
        ]),
        stderr: '',
      );
    }
    return IssueResult(exitCode: 0, stdout: utf8Output, stderr: '');
  }
}

Future<void> main() async {
  final temp = await Directory.systemTemp.createTemp('dashboard_server_test');
  final root = Directory('${temp.path}${Platform.pathSeparator}root');
  await Directory('${root.path}${Platform.pathSeparator}requirements')
      .create(recursive: true);
  await Directory('${root.path}${Platform.pathSeparator}SCRUM.d')
      .create(recursive: true);
  final requirement = File(
      '${root.path}${Platform.pathSeparator}requirements${Platform.pathSeparator}DSH.md');
  await requirement.writeAsString(
    '| ID | status | statement |\n'
    '|---|---|---|\n'
    '| DSH-02 | proposed | Protected ’ — › |\n',
    encoding: utf8,
  );

  final tracker = FakeIssueTracker();
  final server = DashboardServer(
    root: root,
    progressDirectory:
        Directory('${temp.path}${Platform.pathSeparator}progress'),
    issueTracker: tracker,
  );
  const port = 18765;
  await server.start(address: InternetAddress.loopbackIPv4, port: port);
  final client = HttpClient();

  try {
    final badHost = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:$port/sprint'),
    );
    badHost.headers.set(HttpHeaders.hostHeader, 'example.com');
    final badResponse = await badHost.close();
    assertState(badResponse.statusCode == 403, 'bad Host is rejected');
    await badResponse.drain();

    final badOrigin = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:$port/sprint'),
    );
    badOrigin.headers.set('origin', 'http://example.com');
    final originResponse = await badOrigin.close();
    assertState(originResponse.statusCode == 403, 'bad Origin is rejected');
    await originResponse.drain();

    final sprint = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:$port/sprint'),
    );
    sprint.headers.set(HttpHeaders.hostHeader, 'localhost:$port');
    final sprintResponse = await sprint.close();
    assertState(sprintResponse.statusCode == 200, 'local Host is accepted');
    sprintResponse.headers.contentType!.charset == 'utf-8';
    await sprintResponse.drain();

    final missing = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:$port/not-allowed'),
    );
    missing.headers.set(HttpHeaders.hostHeader, '127.0.0.1:$port');
    final missingResponse = await missing.close();
    assertState(
        missingResponse.statusCode == 404, 'unlisted route is rejected');
    await missingResponse.drain();

    assertState(isAllowedStatusMove('backlog', 'planned'),
        'upward transition is allowed');
    assertState(isAllowedStatusMove('planned', 'backlog'),
        'allowed downward transition is allowed');
    assertState(!isAllowedStatusMove('done', 'planned'),
        'invalid reverse transition is rejected');
    assertState(!isAllowedStatusMove('backlog', 'proposed'),
        'proposed is a reverse transition');

    final statusRequest = await client.openUrl(
      'PATCH',
      Uri.parse('http://127.0.0.1:$port/requirements/DSH-02/status'),
    );
    statusRequest.headers.set(HttpHeaders.hostHeader, '127.0.0.1:$port');
    statusRequest.headers.contentType = ContentType.json;
    statusRequest.write(json.encode({'status': 'backlog'}));
    final statusResponse = await statusRequest.close();
    assertState(
        statusResponse.statusCode == 200, 'requirement status update succeeds');
    await statusResponse.drain();
    assertState(
        (await requirement.readAsString())
            .contains('| DSH-02 | backlog | Protected ’ — › |'),
        'only status cell changes');

    final createRequest = await client.openUrl(
      'POST',
      Uri.parse('http://127.0.0.1:$port/requirements'),
    );
    createRequest.headers.set(HttpHeaders.hostHeader, '127.0.0.1:$port');
    createRequest.headers.contentType = ContentType.json;
    createRequest.write(json.encode({
      'id': 'DSH-17',
      'feature': 'DSH',
      'statement': 'New requirement ’ — ›',
    }));
    final createResponse = await createRequest.close();
    assertState(
        createResponse.statusCode == 200, 'requirement creation succeeds');
    await createResponse.drain();
    assertState(
        (await requirement.readAsString()).contains('| DSH-17 | proposed |'),
        'requirement row is added atomically');

    final issueRequest = await client.openUrl(
      'PATCH',
      Uri.parse('http://127.0.0.1:$port/issues/42/status'),
    );
    issueRequest.headers.set(HttpHeaders.hostHeader, 'localhost:$port');
    issueRequest.headers.contentType = ContentType.json;
    issueRequest.write(json.encode({'status': 'planned'}));
    final issueResponse = await issueRequest.close();
    assertState(
        issueResponse.statusCode == 200, 'issue status update succeeds');
    await issueResponse.drain();
    assertState(
        tracker.calls.any((call) =>
            call.contains('--remove-label') && call.contains('--add-label')),
        'issue status uses argument-separated gh command');

    print('PASS dashboard_server_test');
  } finally {
    client.close(force: true);
    await server.close();
    await temp.delete(recursive: true);
  }
}

void assertState(bool condition, String message) {
  if (!condition) throw StateError(message);
}
