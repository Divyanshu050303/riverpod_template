import 'package:blive_delivery_exec/router/app_routes.dart';
import 'package:blive_delivery_exec/style/constants/custom_text_style.dart';
import 'package:flutter/material.dart';

abstract class AppSnackBar {
  AppSnackBar._();

  static void show({
    BuildContext? context,
    Widget? content,
    String? text,
    Duration? duration,
    Color? color,
    EdgeInsets? margin,
  }) {
    appSnackBarMWidget(
      context: context ?? navigatorKey.currentState!.context,
      duration: duration,
      color: color,
      margin: margin,
      content: content ??
          Text(
            text ?? 'Opps! Message is not clear.',
            style: CustomTextStyle.body2M(),
          ),
    );
  }

  static void close({
    BuildContext? context,
  }) {
    ScaffoldMessenger.of(context ?? navigatorKey.currentState!.context)
        .hideCurrentSnackBar();
  }

  static void appSnackBarMWidget({
    required BuildContext context,
    required Widget content,
    Color? color,
    Duration? duration,
    EdgeInsets? margin,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        elevation: 5,
        backgroundColor: color,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
}
