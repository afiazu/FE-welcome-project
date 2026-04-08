import 'package:flutter/material.dart';

void showRightSnackbar(BuildContext context, String message, {bool isError = false}) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: const Offset(1, 0), end: Offset.zero), // Slides from 1 (right) to 0
          builder: (context, offset, child) => FractionalTranslation(
            translation: offset,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? Colors.redAccent : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 3), () => entry.remove());
}