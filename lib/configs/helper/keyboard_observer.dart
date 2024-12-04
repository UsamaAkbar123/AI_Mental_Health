
import 'package:flutter/material.dart';

class KeyboardObserver extends WidgetsBindingObserver {
  final Function(bool) onKeyboardVisibilityChanged;

  KeyboardObserver({required this.onKeyboardVisibilityChanged});

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bool isKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom != 0.0;
    onKeyboardVisibilityChanged(isKeyboardVisible);
  }
}