import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => TeamTaskProvider()),
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
