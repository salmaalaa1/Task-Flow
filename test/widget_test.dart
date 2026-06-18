import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow_app/l10n/translations.dart';
import 'package:taskflow_app/providers/auth_provider.dart';
import 'package:taskflow_app/providers/settings_provider.dart';
import 'package:taskflow_app/screens/settings_screen.dart';
import 'package:taskflow_app/screens/sign_in_screen.dart';

void main() {
  testWidgets('translations rebuild when the global language changes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: Consumer<SettingsProvider>(
          builder: (context, sp, child) {
            return MaterialApp(
              locale: sp.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              home: Builder(builder: (context) => Text(tr(context, 'settings'))),
            );
          },
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);

    await settings.setLanguage('ar');
    await tester.pumpAndSettle();

    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });

  test('selected language is persisted and restored', () async {
    SharedPreferences.setMockInitialValues({});

    final settings = SettingsProvider();
    await settings.setLanguage('ar');

    final restoredSettings = SettingsProvider();
    await restoredSettings.loadPreferences();

    expect(restoredSettings.language, 'ar');
    expect(restoredSettings.locale, const Locale('ar'));
  });

  testWidgets('sign in page uses the selected Arabic language', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsProvider();
    await settings.setLanguage('ar');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, sp, child) {
            return MaterialApp(
              locale: sp.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              home: const SignInScreen(),
            );
          },
        ),
      ),
    );

    expect(find.text('مرحباً بعودتك'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('Email'), findsNothing);

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.text('البريد الإلكتروني مطلوب'), findsOneWidget);
    expect(find.text('كلمة المرور مطلوبة'), findsOneWidget);
  });

  testWidgets('settings Team button uses the selected Arabic language', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsProvider();
    await settings.setLanguage('ar');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, sp, child) {
            return MaterialApp(
              locale: sp.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              home: const Scaffold(body: SettingsScreen()),
            );
          },
        ),
      ),
    );

    expect(find.text('الفريق'), findsOneWidget);
    expect(find.text('Team'), findsNothing);
  });
}
