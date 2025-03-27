import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/services/auth_service.dart';
import 'package:ecommerce_app/core/services/theme_service.dart';
import 'package:ecommerce_app/localization/app_localizations.dart';
import 'package:ecommerce_app/ui/router.dart';
import 'package:ecommerce_app/ui/theme.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
            return RTLWrapper(
              child: MaterialApp(
                title: 'E-Commerce App',
                theme: themeService.isDarkMode ? AppTheme.dark() : AppTheme.light(),
                initialRoute: '/',
                onGenerateRoute: Router.generateRoute,
                debugShowCheckedModeBanner: false,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('es', 'ES'),
                  Locale('ar'),
                  Locale('he'),
                  Locale('fa'),
                ],
                localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}
