import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sattam_app/l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  
  final prefs = await SharedPreferences.getInstance();

  // Restore language
  final savedLang = prefs.getString('languageCode') ?? 'ta';
  appLocale.value = Locale(savedLang, '');

  // Apply Dark System Overlay
  _applySystemOverlay();

  runApp(const SattamApp());
}

void _applySystemOverlay() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
}

final ValueNotifier<Locale> appLocale = ValueNotifier<Locale>(const Locale('ta', ''));

class SattamApp extends StatelessWidget {
  const SattamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'SattamAI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme, // Force Dark Theme as default
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: const SplashScreen(),
        );
      },
    );
  }
}
