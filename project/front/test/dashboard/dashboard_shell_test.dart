import 'package:dashboard_front/data/dashboard_data_interface.dart';
import 'package:dashboard_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('reload refreshes the shared interface and restores loading state',
      (tester) async {
    var reloads = 0;
    final data = _CountingDataInterface(() => reloads++);

    await tester.pumpWidget(DashboardApp(data: data));
    await tester.pumpAndSettle();

    expect(reloads, 1);
    await tester.tap(find.byKey(const Key('reload-button')));
    await tester.pump();
    expect(find.byKey(const Key('reload-progress')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(reloads, 2);
  });

  testWidgets('tracker failure stays in the issues column', (tester) async {
    await tester.pumpWidget(DashboardApp(
      data: InMemoryDashboardDataInterface(issueError: 'offline'),
    ));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'The issue tracker could not be reached: offline',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('dashboard-board')), findsOneWidget);
  });

  testWidgets('server failure stays in the board area', (tester) async {
    await tester.pumpWidget(DashboardApp(
      data: const _ServerFailureDataInterface(),
    ));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'The dashboard server could not be reached: connection refused',
      ),
      findsOneWidget,
    );
  });

  testWidgets('board and lower columns use the 2-of-5 and 3-of-5 split',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(DashboardApp());
    await tester.pumpAndSettle();

    final board = tester.getSize(find.byKey(const Key('dashboard-board')));
    final columns =
        tester.getSize(find.byKey(const Key('dashboard-columns')));
    expect(board.height / (board.height + columns.height), closeTo(0.4, 0.01));
  });

  testWidgets('1280x720 shell has no page overflow', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    await tester.pumpWidget(DashboardApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('dashboard-board')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-columns')), findsOneWidget);
  });

  testWidgets('board and column areas expose independent scroll bars',
      (tester) async {
    await tester.pumpWidget(DashboardApp());
    await tester.pumpAndSettle();
    expect(find.byType(Scrollbar), findsWidgets);
  });
}

class _ServerFailureDataInterface implements DashboardDataInterface {
  const _ServerFailureDataInterface();

  @override
  Future<DashboardSnapshot> reload() async {
    throw Exception('connection refused');
  }
}

class _CountingDataInterface implements DashboardDataInterface {
  _CountingDataInterface(this.onReload);

  final void Function() onReload;

  @override
  Future<DashboardSnapshot> reload() async {
    onReload();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const DashboardSnapshot();
  }
}
