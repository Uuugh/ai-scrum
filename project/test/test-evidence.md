# PBI-002 Test Evidence

## Covered Requirements
- DSH-02、DSH-02.a〜DSH-02.f
- DSH-13、DSH-13.a〜DSH-13.j
- DSH-01.a
- DEF-01 (local address 127.0.0.1, port 8765)

## Results

Run date: 2026-11-22

| Test | Command | Result |
|---|---|---|
| Sprint file preservation | `dart run test/sprint_file_test.dart` | PASS |
| Server security, status, and UTF-8 | `dart run test/dashboard_server_test.dart` | PASS |

## PBI-001 Follow-up

The web and desktop data interfaces now connect to `/sprint`, `/requirements`, `/issues`, `/progress`, and `/usage`.
Reload failures are isolated to the server or affected column. The server request body limit is 1 MiB.

The tests use fictional issue-tracker responses and fictional sprint requirement data. No real schedule, credentials, or secrets are recorded.
