import 'dart:async';

class DashboardSnapshot {
  const DashboardSnapshot({
    this.sprintError,
    this.requirementsError,
    this.issueError,
    this.progressError,
    this.serverError,
  });

  final String? sprintError;
  final String? requirementsError;
  final String? issueError;
  final String? progressError;
  final String? serverError;

  bool get hasTrackerError => issueError != null;
}

abstract interface class DashboardDataInterface {
  Future<DashboardSnapshot> reload();
}

class InMemoryDashboardDataInterface implements DashboardDataInterface {
  InMemoryDashboardDataInterface({this.issueError, this.sprintError});

  final String? issueError;
  final String? sprintError;

  @override
  Future<DashboardSnapshot> reload() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return DashboardSnapshot(
      sprintError: sprintError,
      issueError: issueError,
    );
  }
}
