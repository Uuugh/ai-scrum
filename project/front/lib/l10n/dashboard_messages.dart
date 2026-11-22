class DashboardMessages {
  static const reload = 'Reload';
  static const reloadKey = 'dshReload';
  static const requirements = 'Requirements';
  static const requirementsKey = 'dshRequirements';
  static const issues = 'Issues';
  static const issuesKey = 'dshIssues';
  static const backlog = 'Backlog';
  static const backlogKey = 'dshBacklog';
  static const addBlock = 'Add block';
  static const addBlockKey = 'dshAddBlock';
  static const sprint = 'Sprint';
  static const sprintKey = 'dshKindSprint';
  static const progress = 'Agent progress';
  static const progressKey = 'dshAgentProgress';
  static const addRequirement = 'New requirement';
  static const addRequirementKey = 'dshNewRequirement';
  static const addIssue = 'New issue';
  static const addIssueKey = 'dshNewIssue';
  static const expandAll = 'Expand all';
  static const expandAllKey = 'dshExpandAll';

  static String loadFailure(String reason) => 'Could not be read: $reason';
  static String serverUnreachable(String reason) =>
      'The dashboard server could not be reached: $reason';
  static String trackerFailure(String reason) =>
      'The issue tracker could not be reached: $reason';
}
