import 'package:flutter/material.dart';
import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/lib/core/services/theme_service.dart';
import 'package:ecommerce_app/lib/core/services/locale_service.dart';
import 'package:ecommerce_app/lib/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await ThemeService().init();
  await LocaleService().init();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: App(),
    ),
  );
}