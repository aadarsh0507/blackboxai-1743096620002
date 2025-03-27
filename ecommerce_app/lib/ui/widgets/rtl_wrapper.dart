import 'package:flutter/material.dart';
import 'package:ecommerce_app/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class RTLWrapper extends StatelessWidget {
  final Widget child;

  const RTLWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return Directionality(
      textDirection: appLocalizations?.isRTL ?? false 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: child,
    );
  }
}