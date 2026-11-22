import 'package:flutter/material.dart';

import '../data/dashboard_data_interface.dart';
import '../l10n/dashboard_messages.dart';
import '../theme/dashboard_tokens.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.data,
  });

  final DashboardDataInterface data;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  DashboardSnapshot _snapshot = const DashboardSnapshot();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    try {
      final snapshot = await widget.data.reload();
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      final reason = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _snapshot = DashboardSnapshot(
          serverError: reason,
        );
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DashboardTokens>()!;
    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardHeight = constraints.maxHeight * 2 / 5;
            final lowerHeight = constraints.maxHeight - boardHeight;
            return Column(
              children: [
                SizedBox(
                  key: const Key('dashboard-board'),
                  height: boardHeight,
                  child: _BoardArea(
                    loading: _loading,
                    sprintError: _snapshot.sprintError,
                    serverError: _snapshot.serverError,
                    onReload: _reload,
                  ),
                ),
                SizedBox(
                  key: const Key('dashboard-columns'),
                  height: lowerHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: constraints.maxWidth <= 700
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.requirements,
                                  addLabel: DashboardMessages.addRequirement,
                                  error: _snapshot.requirementsError,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.issues,
                                  addLabel: DashboardMessages.addIssue,
                                  error: _snapshot.issueError,
                                  trackerMessage: _snapshot.issueError,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.progress,
                                  error: _snapshot.progressError,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.requirements,
                                  addLabel: DashboardMessages.addRequirement,
                                  error: _snapshot.requirementsError,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.issues,
                                  addLabel: DashboardMessages.addIssue,
                                  error: _snapshot.issueError,
                                  trackerMessage: _snapshot.issueError,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _DashboardColumn(
                                  title: DashboardMessages.progress,
                                  error: _snapshot.progressError,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BoardArea extends StatelessWidget {
  const _BoardArea({
    required this.loading,
    required this.sprintError,
    required this.serverError,
    required this.onReload,
  });

  final bool loading;
  final String? sprintError;
  final String? serverError;
  final Future<void> Function() onReload;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DashboardTokens>()!;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Text(
                DashboardMessages.backlog,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (loading)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    key: Key('reload-progress'),
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              TextButton(
                key: const Key('reload-button'),
                onPressed: loading ? null : onReload,
                child: const Text(DashboardMessages.reload),
              ),
              IconButton(
                tooltip: DashboardMessages.addBlock,
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              child: ListView(
                primary: false,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                children: [
                  if (sprintError != null)
                    _IsolatedError(
                      message: DashboardMessages.loadFailure(sprintError!),
                    )
                  else if (serverError != null)
                    _IsolatedError(
                      message: DashboardMessages.serverUnreachable(
                          serverError!),
                    )
                  else
                    _BoardCard(label: DashboardMessages.backlog),
                  const SizedBox(width: 12),
                  _BoardCard(label: DashboardMessages.sprint),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  const _BoardCard({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DashboardTokens>()!;
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.soft,
        border: Border.all(color: tokens.line),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label),
    );
  }
}

class _DashboardColumn extends StatelessWidget {
  const _DashboardColumn({
    required this.title,
    this.addLabel,
    this.error,
    this.trackerMessage,
  });

  final String title;
  final String? addLabel;
  final String? error;
  final String? trackerMessage;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DashboardTokens>()!;
    final isolatedMessage = trackerMessage != null
        ? DashboardMessages.trackerFailure(trackerMessage!)
        : error != null
            ? DashboardMessages.loadFailure(error!)
            : null;
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (addLabel != null)
                  IconButton(
                    tooltip: addLabel,
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
          ),
          Expanded(
            child: isolatedMessage != null
                ? _IsolatedError(message: isolatedMessage)
                : Scrollbar(
                    child: ListView.builder(
                          primary: false,
                      padding: const EdgeInsets.all(12),
                      itemCount: 30,
                      itemBuilder: (context, index) =>
                          Text('$title ${index + 1}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _IsolatedError extends StatelessWidget {
  const _IsolatedError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DashboardTokens>()!;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.badBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        message,
        key: const Key('isolated-error'),
        style: TextStyle(color: tokens.bad),
      ),
    );
  }
}
