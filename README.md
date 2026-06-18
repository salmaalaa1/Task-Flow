# Task Flow

Task Flow is a Flutter task management app for personal tasks and secure team workspaces. It uses Firebase Authentication for accounts and Cloud Firestore for users, teams, members, and assigned tasks.

## What The App Does

- Sign up, sign in, sign out, and reset passwords with Firebase Authentication.
- Store user profiles in Firestore.
- Create teams as an Owner.
- Join teams as a Leader or Member with required validated information.
- Assign tasks to a selected team user, including assigning a task to yourself.
- Keep assigned tasks private so only the selected assignee can see and interact with them.
- Let Owners and Leaders manage team tasks from role-specific dashboards.
- Let Members and Leaders update only their own assigned task status and notes.
- Switch the whole app between English and Arabic and remember the selected language.
- Keep local preferences such as theme and language with Hive/shared preferences.

## Roles

| Role | Main Abilities |
| --- | --- |
| Owner | Creates teams, sees team workload, assigns tasks, deletes owned team data. |
| Leader | Views leader dashboard, assigns/manages team tasks, sees assigned personal tasks. |
| Member | Sees only tasks assigned to their own account and updates their own task status/notes. |

## Tech Stack

| Area | Tooling |
| --- | --- |
| Framework | Flutter |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Local storage | Hive / shared preferences |
| State management | Provider |
| Tests | Flutter test |

## Project Structure

```text
lib/
  main.dart                         App startup, Firebase init, providers, routing
  firebase_options.dart             FlutterFire generated Firebase config
  config/                           App-level config helpers
  l10n/translations.dart            English and Arabic translation keys
  models/                           User, task, event, and team task models
  providers/                        Auth, settings, team, task, and team-task state
  screens/                          Auth pages, dashboards, team pages, task pages
  services/
    firebase_auth_service.dart      Firebase Authentication wrapper
    firestore_database_service.dart Firestore CRUD, joins, streams, task privacy

android/                            Android build configuration
firestore.rules                     Firestore security rules
firebase.json                       Firebase deploy configuration
test/                               Provider and widget tests
```

## Firestore Data Model

```text
users/{uid}
  uid
  name
  email
  createdAt
  updatedAt

teams/{teamId}
  name
  normalizedName
  description
  joinPasswordHash
  ownerUserId
  memberIds[]
  createdAt
  updatedAt

teams/{teamId}/members/{uid}
  userId
  name
  email
  department
  role: owner | leader | member
  joinedAt
  updatedAt

teams/{teamId}/tasks/{taskId}
  id
  title
  note
  status
  assignedTo
  assignedToUserId
  createdByUserId
  createdByRole
  createdAt
  updatedAt
```

## Security And Privacy

Task Flow protects task visibility in two places:

- Flutter filters task lists by the signed-in user's UID.
- Firestore rules only allow a member to read/update tasks where `assignedToUserId == request.auth.uid`.

Owners and Leaders can create tasks for a selected user. Members can only update `status` and `note` on their own assigned tasks.

## Firebase Setup

1. Create a Firebase project.
2. Enable Authentication.
3. Enable the Email/Password sign-in provider.
4. Create a Cloud Firestore database.
5. Install the Firebase CLI and FlutterFire CLI.

```powershell
dart pub global activate flutterfire_cli
flutterfire configure
```

6. Make sure these files exist in the project:

```text
lib/firebase_options.dart
android/app/google-services.json
.firebaserc
firebase.json
```

7. Deploy Firestore rules.

```powershell
firebase deploy --only firestore:rules
```

## Run The App

Install dependencies:

```powershell
flutter pub get
```

Run on web:

```powershell
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 51518
```

Open:

```text
http://127.0.0.1:51518/
```

## Build Android APK

Build a release APK:

```powershell
flutter build apk --release
```

The APK will be created at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

To copy/extract the APK to your Downloads folder:

```powershell
Copy-Item "build\app\outputs\flutter-apk\app-release.apk" "$env:USERPROFILE\Downloads\task-flow-release.apk" -Force
```

## Test And Analyze

Run tests:

```powershell
flutter test
```

Run analyzer:

```powershell
flutter analyze
```

The tests cover language persistence, Arabic/English rebuilds, team join validation, deleted-team behavior, and assigned-task privacy.

## Example Firestore CRUD

```dart
final auth = FirebaseAuthService();
final db = FirestoreDatabaseService();

final credential = await auth.signUp(
  email: 'member@example.com',
  password: 'strong-password',
);

await db.createUserProfile(
  uid: credential.user!.uid,
  name: 'Team Member',
  email: 'member@example.com',
);

final team = await db.createTeam(
  name: 'Design Ops',
  description: 'Product design work',
  password: 'join-code',
  ownerUserId: credential.user!.uid,
  ownerName: 'Team Owner',
  ownerEmail: 'owner@example.com',
);

await db.createTask(
  teamId: team.id,
  task: TeamTask(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: 'Prepare weekly report',
    assignedTo: 'Team Member',
    assignedToUserId: 'member-uid',
  ),
  createdByUserId: credential.user!.uid,
  createdByRole: 'owner',
);

final myTasksStream = db.watchAssignedTasks(
  teamId: team.id,
  userId: 'member-uid',
);
```

## Current Notes

- Firestore rules must be deployed after changes to `firestore.rules`.
- The Android APK requires valid Firebase Android configuration.
- `google-services.json` is project configuration, not an admin secret, but it should still belong only to the intended Firebase project.
