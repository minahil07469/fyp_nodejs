import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// Show a styled flushbar at the top of the screen.
///
/// [isError] → red background (default)
/// [isError] = false → green background (success)
void showFlushbar(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  Flushbar(
    message: message,
    messageSize: 14,
    backgroundColor: isError ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
    icon: Icon(
      isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
      color: Colors.white,
      size: 22,
    ),
    leftBarIndicatorColor: isError ? const Color(0xFFFF6B6B) : const Color(0xFF66BB6A),
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 350),
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    messageColor: Colors.white,
  ).show(context);
}
