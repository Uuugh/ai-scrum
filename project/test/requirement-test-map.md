# Dashboard Requirement-to-Test Map

The source is `C:\Users\rfrie\Development\Projects\CalendarStream-dashboard\requirements`. The source repository remains unchanged. These are planned test locations and coverage; the test files will be added with their implementation.

| Source IDs | Planned test | Coverage |
|---|---|---|
| DSH-01, DSH-01.a–DSH-01.g; DSH-15, DSH-15.a–DSH-15.c | `project/front/test/dashboard/dashboard_shell_test.dart` | Web and desktop interface, reload and load failures, shared data interface, theme, responsive layout, and independent scrolling |
| DSH-02, DSH-02.a–DSH-02.f | `project/back/test/sprint_file_test.dart` | Sprint file schema, atomic updates, initial empty state, and preservation of content the dashboard does not edit |
| DSH-03, DSH-03.a–DSH-03.c; DSH-04, DSH-04.a–DSH-04.d; DSH-11, DSH-11.a–DSH-11.i | `project/front/test/dashboard/requirements_column_test.dart` | Requirement listing, combined filters, counts, tree layout, expansion, and empty or orphaned sub-requirements |
| DSH-05, DSH-05.a–DSH-05.e | `project/front/test/dashboard/issues_column_test.dart` | Issue metadata, status and feature derivation, missing values, ordering, and truncation |
| DSH-06, DSH-06.a–DSH-06.e; DSH-07, DSH-07.a–DSH-07.h; DSH-08, DSH-08.a–DSH-08.b; DSH-10, DSH-10.a–DSH-10.c | `project/front/test/dashboard/sprint_board_test.dart` | Block creation, nesting, drag/drop transitions, acceptance, and estimate/usage totals |
| DSH-09, DSH-09.a–DSH-09.g | `project/front/test/dashboard/issue_form_test.dart` | Field dependencies, validation, cancel, creation, refresh, and failure handling |
| DSH-12, DSH-12.a–DSH-12.d; DSH-14, DSH-14.a–DSH-14.g | `project/front/test/dashboard/progress_usage_test.dart` | Progress file parsing and refresh, usage readings, estimates, missing data, and values over 100 |
| DSH-13, DSH-13.a–DSH-13.j | `project/back/test/dashboard_server_test.dart` | Local binding, Host/Origin checks, allowed operations, status transitions, atomic requirement updates, issue command handling, and UTF-8 responses |
| DSH-16, DSH-16.a–DSH-16.j | `project/front/test/dashboard/add_popup_test.dart` | Shared add flow, optional IDs, suggestions, selection, placement, and invalid ID handling |
| UIC-01, UIC-12, UIC-13, UIC-21, UIC-24; DEF-01; THM-02 and its sub-requirements; `msg:dsh*` | `project/front/test/dashboard/shared_requirements_test.dart` and `project/front/test/l10n/dashboard_messages_test.dart` | Dialogs, shared dropdown/filter behavior, immediate updates, defaults, theme tokens, and message-key coverage |

## Readiness

The mapping is a test plan, not test evidence. A PBI is not done until its named tests exist and pass on its agreed target platforms.
