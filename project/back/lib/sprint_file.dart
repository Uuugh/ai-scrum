import 'dart:convert';
import 'dart:io';

/// Reads and atomically updates the dashboard sprint markdown file.
class SprintFileStore {
  SprintFileStore(this.file);

  final File file;

  Future<String> read() async {
    if (!await file.exists()) return '';
    return file.readAsString(encoding: utf8);
  }

  Future<void> writeText(String text) async {
    await _atomicWrite(text);
  }

  /// Replaces only the named dashboard tables.
  /// Review and Retrospective text, and all text outside dashboard tables,
  /// remains exactly as it was.
  Future<void> update({
    List<Map<String, dynamic>>? blocks,
    List<Map<String, dynamic>>? members,
  }) async {
    var text = await read();
    if (text.isEmpty) text = '# Sprint\n\n';

    if (blocks != null) {
      text = _replaceSectionTable(
        text,
        'Blocks',
        [
          '| Block ID | Kind | Name | Parent block ID | Assignee | Estimate | Usage |',
          '|---|---|---|---|---|---:|---:|',
          ...blocks.map(_blocksRow),
        ],
      );
    }
    if (members != null) {
      text = _replaceSectionTable(
        text,
        'Members',
        [
          '| Block ID | Requirement or issue |',
          '|---|---|',
          ...members.map(
              (row) => '| ${row['blockId'] ?? ''} | ${row['item'] ?? ''} |'),
        ],
      );
    }
    await _atomicWrite(text);
  }

  String _blocksRow(Map<String, dynamic> row) =>
      '| ${row['id'] ?? ''} | ${row['kind'] ?? ''} | ${row['name'] ?? ''} | '
      '${row['parentId'] ?? ''} | ${row['assignee'] ?? ''} | '
      '${row['estimate'] ?? ''} | ${row['usage'] ?? ''} |';

  String _replaceSectionTable(
      String source, String heading, List<String> table) {
    final newline = source.contains('\r\n') ? '\r\n' : '\n';
    final lines = source.split(RegExp(r'\r?\n'));
    final separator = heading == 'Blocks' ? 7 : 2;
    final unreadable = <String>[];
    var oldStart = -1;
    var oldEnd = lines.length;
    final headingPattern = RegExp(
        r'^#{1,6}\s*' + RegExp.escape(heading) + r'\s*$',
        caseSensitive: false);
    var start = -1;
    var end = lines.length;
    for (var i = 0; i < lines.length; i++) {
      if (headingPattern.hasMatch(lines[i])) {
        start = i;
        break;
      }
    }
    if (start >= 0) {
      for (var i = start + 1; i < lines.length; i++) {
        if (RegExp(r'^#{1,6}\s').hasMatch(lines[i])) {
          end = i;
          break;
        }
      }
      oldStart = start + 1;
      oldEnd = end;
      for (var i = oldStart; i < oldEnd; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('|')) continue;
        final cells = _markdownCells(line);
        if (line.startsWith('|---') || line.startsWith('| ---')) continue;
        if (cells.length != separator ||
            cells.first.isEmpty ||
            (heading == 'Blocks' && !RegExp(r'^.+$').hasMatch(cells[0]))) {
          unreadable.add(lines[i]);
        }
      }
      final replacement = <String>[
        lines[start],
        '',
        ...table,
        ...unreadable,
        '',
      ];
      lines.replaceRange(start, end, replacement);
    } else {
      final insertion = <String>['', '## $heading', '', ...table, ''];
      lines.addAll(insertion);
    }
    final joined = lines.join(newline);
    if (source.endsWith('\n') && !joined.endsWith('\n'))
      return '$joined$newline';
    return joined;
  }

  Future<void> _atomicWrite(String text) async {
    await file.parent.create(recursive: true);
    final temp = File(
      '${file.parent.path}${Platform.pathSeparator}.${file.uri.pathSegments.last}.'
      '${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    await temp.writeAsBytes(utf8.encode(text), flush: true);
    await temp.rename(file.path);
  }
}

/// Atomically changes one status cell in a Markdown table.
Future<void> updateRequirementStatus({
  required File file,
  required String requirementId,
  required String status,
}) async {
  if (!await file.exists())
    throw FileSystemException('Requirement file not found', file.path);
  final bytes = await file.readAsBytes();
  final text = utf8.decode(bytes, allowMalformed: false);
  final lines = text.split(RegExp(r'\r?\n'));
  var statusColumn = -1;
  var rowIndex = -1;

  for (var i = 0; i < lines.length; i++) {
    final row = _markdownCells(lines[i]);
    if (row.isNotEmpty &&
        row[0].toLowerCase() == 'id' &&
        i + 1 < lines.length) {
      for (var c = 0; c < row.length; c++) {
        if (row[c].trim().toLowerCase() == 'status') statusColumn = c;
      }
    }
    if (row.isNotEmpty && row.length > 1 && row[0].trim() == requirementId) {
      rowIndex = i;
    }
  }
  if (statusColumn < 0) throw ArgumentError('Status column not found');
  if (rowIndex < 0) throw ArgumentError('Requirement $requirementId not found');

  final row = _markdownCells(lines[rowIndex], includeSeparators: true);
  if (statusColumn >= row.length) throw ArgumentError('Invalid status column');
  row[statusColumn] = ' $status ';
  lines[rowIndex] = '|${row.join('|')}|';
  await atomicWriteFile(file, lines.join('\n'));
}

List<String> _markdownCells(String line, {bool includeSeparators = false}) {
  var trimmed = line.trim();
  if (!trimmed.startsWith('|')) return <String>[];
  trimmed = trimmed.substring(1);
  if (trimmed.endsWith('|')) trimmed = trimmed.substring(0, trimmed.length - 1);
  return trimmed
      .split('|')
      .map((value) => includeSeparators ? value : value.trim())
      .toList();
}

Future<void> atomicWriteFile(File file, String text) async {
  await file.parent.create(recursive: true);
  final temp = File(
    '${file.parent.path}${Platform.pathSeparator}.${file.uri.pathSegments.last}.'
    '${DateTime.now().microsecondsSinceEpoch}.tmp',
  );
  await temp.writeAsBytes(utf8.encode(text), flush: true);
  await temp.rename(file.path);
}
