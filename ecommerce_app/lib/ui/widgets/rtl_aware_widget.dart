import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/rtl_utils.dart';

class RTLAwareWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Alignment? alignment;

  const RTLAwareWidget({
    super.key,
    required this.child,
    this.padding,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment ?? 
          (RTLUtils.isRTL(context) ? Alignment.centerRight : Alignment.centerLeft),
      child: Directionality(
        textDirection: RTLUtils.getDirection(context),
        child: child,
      ),
    );
  }
}