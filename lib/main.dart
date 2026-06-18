import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'models/user_model.g.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/team_provider.dart';
import 'providers/team_task_provider.dart';
import 'providers/event_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'services/firebase_auth_service.dart';
import 'services/firestore_database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase powers Authentication and Firestore data storage.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('tasks'); // generic box for task maps
  await Hive.openBox('events'); // generic box for event maps
  await Hive.openBox('team'); // generic box for team data
  await Hive.openBox('team_tasks'); // generic box for team tasks

  // Load settings eagerly
  final settings = SettingsProvider();
  await settings.loadPreferences();

  runApp(TaskFlowApp(settings: settings));
}

class TaskFlowApp extends StatelessWidget {
  final SettingsProvider settings;
  const TaskFlowApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    final databaseService = FirestoreDatabaseService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService, databaseService: databaseService),
        ),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider(databaseService: databaseService)),
        ChangeNotifierProvider(create: (_) => TeamTaskProvider(databaseService: databaseService)),
        ChangeNotifierProvider.value(value: settings),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, sp, child) {
          return MaterialApp(
            title: 'TaskFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: sp.themeMode,
            locale: sp.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return sp.locale;
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return sp.locale;
            },
            builder: (context, child) {
              final locale = Localizations.localeOf(context);
              return Directionality(textDirection: locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr, child: child!);
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
