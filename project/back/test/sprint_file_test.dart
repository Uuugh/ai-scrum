import 'dart:io';

import 'package:dashboard_back/sprint_file.dart';

Future<void> main() async {
  final temp = await Directory.systemTemp.createTemp('sprint_file_test');
  try {
    final file = File('${temp.path}${Platform.pathSeparator}SCRUM.d'
        '${Platform.pathSeparator}sprint.md');
    final store = SprintFileStore(file);

    assertState(await store.read() == '', 'missing sprint is empty');
    await store.update(blocks: [
      {
        'id': 'S-1',
        'kind': 'story',
        'name': 'Safe input',
        'estimate': '3',
        'usage': '1',
      }
    ], members: [
      {'blockId': 'S-1', 'item': 'DSH-02'},
    ]);
    var text = await store.read();
    assertState(text.contains('Safe input'), 'UTF-8 sprint text is written');
    assertState(text.contains('DSH-02'), 'member is written');

    text = text.replaceFirst('# Sprint', '# Sprint\n\nProtected preface ’ — ›');
    await store.writeText(text);
    await store.update(blocks: [
      {
        'id': 'S-2',
        'kind': 'story',
        'name': 'Updated',
      }
    ]);
    final preserved = await store.read();
    assertState(preserved.contains('Protected preface ’ — ›'),
        'text outside dashboard tables is preserved');
    assertState(preserved.contains('S-2'), 'block table is updated');

    print('PASS sprint_file_test');
  } finally {
    await temp.delete(recursive: true);
  }
}

void assertState(bool condition, String message) {
  if (!condition) throw StateError(message);
}
