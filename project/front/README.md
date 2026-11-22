# CalendarStream Dashboard Frontend

## Prerequisites

- Flutter stable 3.44 or compatible
- Dart 3.12 or compatible

## Build and test

```powershell
cd project/front
flutter pub get
flutter analyze
flutter test test/dashboard/dashboard_shell_test.dart
flutter build web
flutter build windows
```

The Windows build target is only available on a Windows host.

## Entry points

- `lib/main.dart`: Web entry point and shared application shell
- `lib/main_desktop.dart`: Desktop entry point

The application uses only Flutter SDK dependencies. It does not add a package or secret beyond the approved manifest.
