import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'sprint_file.dart';

const dashboardAddress = '127.0.0.1';
const dashboardPort = 8765;
const dashboardMaxRequestBytes = 1024 * 1024;

abstract interface class IssueTracker {
  Future<IssueResult> run(List<String> arguments);
}

class GhIssueTracker implements IssueTracker {
  GhIssueTracker({this.executable = 'gh'});
  final String executable;

  @override
  Future<IssueResult> run(List<String> arguments) async {
    final result = await Process.run(
      executable,
      arguments,
      runInShell: false,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    return IssueResult(
      exitCode: result.exitCode,
      stdout: result.stdout is String
          ? result.stdout as String
          : utf8.decode(result.stdout as List<int>, allowMalformed: true),
      stderr: result.stderr is String
          ? result.stderr as String
          : utf8.decode(result.stderr as List<int>, allowMalformed: true),
    );
  }
}

class IssueResult {
  IssueResult(
      {required this.exitCode, required this.stdout, required this.stderr});
  final int exitCode;
  final String stdout;
  final String stderr;
}

bool isAllowedStatusMove(String from, String to) {
  const order = ['proposed', 'backlog', 'planned', 'done'];
  final oldIndex = order.indexOf(from);
  final newIndex = order.indexOf(to);
  if (oldIndex < 0 || newIndex < 0) return false;
  if (newIndex > oldIndex) return true;
  return from == 'planned' && to == 'backlog';
}

class DashboardServer {
  DashboardServer({
    required Directory root,
    required Directory progressDirectory,
    IssueTracker? issueTracker,
  })  : root = root,
        progressDirectory = progressDirectory,
        issueTracker = issueTracker ?? GhIssueTracker();

  final Directory root;
  final Directory progressDirectory;
  final IssueTracker issueTracker;
  HttpServer? _server;
  late SprintFileStore _sprintStore;
  int _port = dashboardPort;

  Future<void> start({
    InternetAddress? address,
    int port = dashboardPort,
  }) async {
    _port = port;
    final sprintFile = File('${root.path}${Platform.pathSeparator}SCRUM.d'
        '${Platform.pathSeparator}sprint.md');
    _sprintStore = SprintFileStore(sprintFile);
    _server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
      shared: false,
    );
    _server!.listen(_handle);
  }

  Future<void> close() async => _server?.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    if (!_validRequest(request)) {
      await _json(request, 403, {'error': 'Forbidden Host or Origin'});
      return;
    }
    final path = request.uri.path;
    try {
      if (request.method == 'GET' && path == '/sprint') {
        await _json(request, 200, {
          'text': await _sprintStore.read(),
          'file': _sprintStore.file.path,
        });
      } else if ((request.method == 'PUT' || request.method == 'PATCH') &&
          path == '/sprint') {
        await _writeSprint(request);
      } else if (request.method == 'GET' && path == '/requirements') {
        await _json(request, 200, await _listRequirements());
      } else if (request.method == 'PATCH' &&
          RegExp(r'^/requirements/([^/]+)/status$').firstMatch(path) != null) {
        await _setRequirementStatus(request, path);
      } else if (request.method == 'POST' && path == '/requirements') {
        await _createRequirement(request);
      } else if (request.method == 'GET' && path == '/issues') {
        await _json(request, 200, await _listIssues());
      } else if (request.method == 'POST' && path == '/issues') {
        await _createIssue(request);
      } else if (request.method == 'PATCH' &&
          RegExp(r'^/issues/([^/]+)/status$').firstMatch(path) != null) {
        await _setIssueStatus(request, path);
      } else if (request.method == 'GET' && path == '/progress') {
        await _listProgress(request);
      } else if (request.method == 'GET' && path == '/usage') {
        await _json(request, 200, await _usage());
      } else {
        await _json(request, 404, {'error': 'Not found'});
      }
    } catch (error) {
      await _json(request, 400, {'error': error.toString()});
    }
  }

  bool _validRequest(HttpRequest request) {
    final host = request.headers.value(HttpHeaders.hostHeader)?.trim();
    if (host == null) return false;
    final hostOnly = host.toLowerCase();
    if (hostOnly != '$dashboardAddress:$_port' &&
        hostOnly != 'localhost:$_port' &&
        hostOnly != '$dashboardAddress' &&
        hostOnly != 'localhost') return false;
    final origin = request.headers.value('origin');
    if (origin == null || origin.isEmpty) return true;
    final uri = Uri.tryParse(origin);
    if (uri == null) return false;
    return (uri.host == dashboardAddress || uri.host == 'localhost') &&
        (uri.hasPort ? uri.port == _port : uri.scheme == 'http');
  }

  Future<Map<String, dynamic>> _body(HttpRequest request) async {
    final contentLength = request.headers.contentLength;
    if (contentLength > dashboardMaxRequestBytes) {
      throw ArgumentError('Request body exceeds 1 MiB');
    }
    var received = 0;
    final bytes = await request.fold<List<int>>(<int>[], (all, part) {
      received += part.length;
      if (received > dashboardMaxRequestBytes) {
        throw ArgumentError('Request body exceeds 1 MiB');
      }
      return all..addAll(part);
    });
    if (bytes.isEmpty) return {};
    return json.decode(utf8.decode(bytes, allowMalformed: false))
        as Map<String, dynamic>;
  }

  Future<void> _json(HttpRequest request, int status, Object body) async {
    request.response.statusCode = status;
    request.response.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');
    request.response.write(json.encode(body));
    await request.response.close();
  }

  Future<void> _writeSprint(HttpRequest request) async {
    final body = await _body(request);
    if (body.containsKey('text')) {
      await _sprintStore.writeText(body['text'].toString());
    } else {
      await _sprintStore.update(
        blocks: (body['blocks'] as List<dynamic>?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList(),
        members: (body['members'] as List<dynamic>?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList(),
      );
    }
    await _json(request, 200, {'text': await _sprintStore.read()});
  }

  Future<List<Map<String, dynamic>>> _listRequirements() async {
    final requirementsDir = Directory(
      '${root.path}${Platform.pathSeparator}requirements',
    );
    final result = <Map<String, dynamic>>[];
    if (!await requirementsDir.exists()) return result;
    await for (final entity
        in requirementsDir.list(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      final name = entity.uri.pathSegments.last;
      if (name == 'README.md' ||
          name == 'oldkey.md' ||
          name == 'open-questions.md') continue;
      final text = await entity.readAsString(encoding: utf8);
      for (final line in const LineSplitter().convert(text)) {
        final cells = _rowCells(line);
        if (cells.length >= 3 &&
            RegExp(r'^[A-Z]+-[0-9]+(?:\.[a-z]?)?$').hasMatch(cells[0])) {
          result.add({
            'id': cells[0],
            'status': cells.length > 1
                ? (cells[1].isEmpty ? 'backlog' : cells[1])
                : 'backlog',
            'statement': cells.length > 2 ? cells[2] : '',
            'file': entity.path,
          });
        }
      }
    }
    return result;
  }

  List<String> _rowCells(String line) {
    var value = line.trim();
    if (!value.startsWith('|') || !value.endsWith('|')) return <String>[];
    value = value.substring(1, value.length - 1);
    return value.split('|').map((cell) => cell.trim()).toList();
  }

  Future<void> _setRequirementStatus(HttpRequest request, String path) async {
    final id =
        RegExp(r'^/requirements/([^/]+)/status$').firstMatch(path)!.group(1)!;
    final body = await _body(request);
    final status = body['status']?.toString();
    if (status == null) throw ArgumentError('Missing status');
    final requirements = await _listRequirements();
    final match = requirements.where((item) => item['id'] == id).toList();
    if (match.isEmpty) throw ArgumentError('Requirement $id not found');
    final old = match.first['status'].toString();
    if (!isAllowedStatusMove(old, status)) {
      throw ArgumentError('Status change refused: $old -> $status');
    }
    await updateRequirementStatus(
      file: File(match.first['file'].toString()),
      requirementId: id,
      status: status,
    );
    await _json(request, 200, {'id': id, 'status': status});
  }

  Future<void> _createRequirement(HttpRequest request) async {
    final body = await _body(request);
    final id = body['id']?.toString();
    final feature = body['feature']?.toString();
    final statement = body['statement']?.toString();
    if (id == null || feature == null || statement == null) {
      throw ArgumentError('id, feature, and statement are required');
    }
    final requirements = await _listRequirements();
    if (requirements.any((item) => item['id'] == id)) {
      throw ArgumentError('Requirement $id already exists');
    }
    final prefix = id.contains('-') ? id.substring(0, id.indexOf('-')) : '';
    if (prefix != feature) {
      throw ArgumentError('Requirement ID prefix must match feature $feature');
    }
    final parentId = body['parentId']?.toString();
    if (parentId != null && parentId.isNotEmpty) {
      if (!requirements.any((item) => item['id'] == parentId)) {
        throw ArgumentError('Parent requirement $parentId does not exist');
      }
    }

    final requirementsDir =
        Directory('${root.path}${Platform.pathSeparator}requirements');
    File? file;
    await for (final entity
        in requirementsDir.list(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      final stem =
          entity.uri.pathSegments.last.replaceFirst(RegExp(r'\.md$'), '');
      if (stem == feature) file = entity;
    }
    if (file == null) {
      file = File(
        '${requirementsDir.path}${Platform.pathSeparator}$feature.md',
      );
      await file.parent.create(recursive: true);
      await file.writeAsString(
        '| ID | status | statement | test | evidence |\n'
        '|---|---|---|---|---|\n',
        encoding: utf8,
        flush: true,
      );
    }

    final text = await file.readAsString(encoding: utf8);
    final newline = text.contains('\r\n') ? '\r\n' : '\n';
    final lines = text.split(RegExp(r'\r?\n'));
    var insertAt = lines.length;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('|---')) continue;
      if (parentId != null && parentId.isNotEmpty) {
        final cells = _rowCells(lines[i]);
        if (cells.isNotEmpty && cells.first == parentId) {
          insertAt = i + 1;
          for (var j = i + 1; j < lines.length; j++) {
            final subCells = _rowCells(lines[j]);
            if (subCells.isNotEmpty &&
                subCells.first.startsWith('$parentId.')) {
              insertAt = j + 1;
            } else if (subCells.isNotEmpty) {
              break;
            }
          }
          break;
        }
      }
    }
    if (parentId == null || parentId.isEmpty) {
      insertAt = lines.length;
    }
    lines.insert(insertAt, '| $id | proposed | $statement | — | — |');
    await atomicWriteFile(file, lines.join(newline));
    await _json(request, 200, {
      'id': id,
      'status': 'proposed',
      'feature': feature,
    });
  }

  Future<List<Map<String, dynamic>>> _listIssues() async {
    final result = await issueTracker.run([
      'issue',
      'list',
      '--limit',
      '200',
      '--json',
      'number,title,state,labels'
    ]);
    if (result.exitCode != 0)
      throw Exception(result.stderr.isNotEmpty ? result.stderr : result.stdout);
    if (result.stdout.trim().isEmpty) return [];
    final decoded = json.decode(result.stdout);
    if (decoded is List) {
      return decoded
          .cast<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  Future<void> _createIssue(HttpRequest request) async {
    final body = await _body(request);
    final title = body['title']?.toString();
    final description = body['description']?.toString() ?? '';
    final feature = body['feature']?.toString();
    if (title == null || feature == null)
      throw ArgumentError('title and feature are required');
    final args = <String>[
      'issue',
      'create',
      '--title',
      title,
      '--body',
      '$description\n\nRequirement: ${body['requirementId'] ?? ''}',
      '--label',
      'issue',
      '--label',
      'feature:$feature',
      '--label',
      'backlog',
    ];
    final result = await issueTracker.run(args);
    if (result.exitCode != 0) {
      throw Exception(result.stderr.isNotEmpty ? result.stderr : result.stdout);
    }
    await _json(request, 200, {'output': result.stdout});
  }

  Future<void> _setIssueStatus(HttpRequest request, String path) async {
    final number =
        RegExp(r'^/issues/([^/]+)/status$').firstMatch(path)!.group(1)!;
    final body = await _body(request);
    final status = body['status']?.toString();
    if (status == null) throw ArgumentError('Missing status');
    final issues = await _listIssues();
    final match =
        issues.where((item) => item['number'].toString() == number).toList();
    if (match.isEmpty) throw ArgumentError('Issue #$number not found');
    final labels = <String>[];
    final rawLabels = match.first['labels'];
    if (rawLabels is List) {
      for (final item in rawLabels) {
        if (item is Map) labels.add(item['name']?.toString() ?? '');
        if (item is String) labels.add(item);
      }
    }
    final old = labels.firstWhere(
      (label) => ['proposed', 'backlog', 'planned', 'done'].contains(label),
      orElse: () => 'backlog',
    );
    if (!isAllowedStatusMove(old, status)) {
      throw ArgumentError('Status change refused: $old -> $status');
    }
    final args = <String>['issue', 'edit', number];
    for (final label in ['proposed', 'backlog', 'planned', 'done']) {
      args.addAll(['--remove-label', label]);
    }
    args.addAll(['--add-label', status]);
    final result = await issueTracker.run(args);
    if (result.exitCode != 0) {
      throw Exception(result.stderr.isNotEmpty ? result.stderr : result.stdout);
    }
    await _json(request, 200, {'number': number, 'status': status});
  }

  Future<void> _listProgress(HttpRequest request) async {
    final files = <Map<String, dynamic>>[];
    if (await progressDirectory.exists()) {
      await for (final entity in progressDirectory.list(followLinks: false)) {
        if (entity is! File) continue;
        final content = await entity.readAsString(encoding: utf8);
        final match = RegExp(r'^(\d+)\/(\d+)$').firstMatch(content.trim());
        if (match != null) {
          files.add({
            'name': entity.uri.pathSegments.last,
            'done': int.parse(match.group(1)!),
            'total': int.parse(match.group(2)!),
          });
        }
      }
    }
    await _json(request, 200, files);
  }

  Future<Map<String, dynamic>> _usage() async {
    final file = File('${root.path}${Platform.pathSeparator}SCRUM.d'
        '${Platform.pathSeparator}usage.md');
    if (!await file.exists()) return {'table': null};
    return {'text': await file.readAsString(encoding: utf8)};
  }
}
