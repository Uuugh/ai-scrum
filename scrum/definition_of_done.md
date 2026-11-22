# Definition of Done

## Product
CalendarStream Dashboard, built with Dart and Flutter under `project/front` and `project/back` from the dashboard requirements and their linked shared requirements.

Each item below must be answered Yes for its PBI to be done.

### Requirements and tests
- The PBI maps to the source requirement IDs and adds no behavior beyond them.
- The PBI acceptance criteria include its DSH and linked UIC, THM or DEF requirement mapping.
- `project/test/` contains the requirement-to-test map and test evidence for every included requirement.
- Every included acceptance criterion has a test with a clear pass or fail result.
- All tests for the PBI pass on its agreed target platforms.

### Code quality
- Dart and Flutter code follows the project's feature and layer boundaries.
- No dependency is added without Product Owner approval.

### Runtime behavior
- The web and desktop apps run as required by the mapped DSH requirements.
- The local server follows DSH-13 and exposes no token or secret.

### UI and localization
- Every displayed label, heading, or note uses the cited message keys and translations.
- Shared UI and theme behavior follows the linked requirements.

### Documentation
- English instructions explain how to build, test, and run the app.
- The smoke check records the platform and result.
- Made-up data is used in tests; no real schedule or credentials are recorded.

## History
See [definition_of_done_history.md](definition_of_done_history.md).