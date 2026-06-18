# TaskFlow

TaskFlow is a Flutter task management app for personal work and team workspaces. It supports owners, team leaders, and members with role-specific dashboards, local account sessions, team joining, language switching, and private task assignment.

## Features

- Global language switching between English and Arabic.
- Selected language is persisted and automatically applied across pages and components.
- Dark mode, notifications, sound preferences, and profile editing.
- Local sign up, sign in, password reset, and profile updates.
- Owner team creation with required team name, description, and password.
- Validated team joining with authenticated user details, valid department selection, matching team password, duplicate prevention, and deleted-team blocking.
- Owner and leader dashboards for team task management.
- Task assignment privacy: tasks assigned by an owner or team leader are visible and editable only by the selected member or leader.
- Member and leader task actions are guarded so users cannot update notes or status on tasks assigned to another account.
- Local persistence through Hive and shared preferences.

## Project Structure

- `lib/main.dart` wires providers, localization, theme mode, and app routing.
- `lib/l10n/translations.dart` contains app translation keys.
- `lib/providers/` contains auth, settings, team, task, and team-task state.
- `lib/screens/` contains the app dashboards, auth pages, settings, and task flows.
- `lib/models/` contains persisted data models.
- `test/` contains widget and provider tests for localization, team joining, and task privacy.

## Requirements

- Flutter SDK
- Dart SDK from Flutter
- A browser for Flutter web

## Run Locally

```powershell
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 51518
```

Then open:

```text
http://127.0.0.1:51518/
```

## Test

```powershell
flutter test
```

The test suite covers:

- Global language rebuild and persistence.
- Team join validation.
- Assigned-task privacy and guarded member interactions.

## Analyze

```powershell
flutter analyze
```

The current app may still report existing cleanup warnings for unused helper methods and style hints, but the implemented language, join-validation, and task-privacy flows are covered by tests.
