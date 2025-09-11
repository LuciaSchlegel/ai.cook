import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Utility functions for handling modal bottom sheets with proper keyboard behavior
class ModalUtils {
  /// Shows a keyboard-aware modal bottom sheet
  ///
  /// This wrapper ensures that modal bottom sheets properly adjust to keyboard visibility
  /// by adding appropriate padding and scroll behavior.
  static Future<T?> showKeyboardAwareModalBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color backgroundColor = Colors.transparent,
    AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: useSafeArea,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      transitionAnimationController: transitionAnimationController,
      builder: (context) => KeyboardAwareModalWrapper(child: child),
    );
  }

  /// Shows a keyboard-aware Cupertino modal popup
  ///
  /// This wrapper ensures that Cupertino modal popups properly adjust to keyboard visibility
  /// by adding appropriate padding. Useful for pickers with text input fields.
  static Future<T?> showKeyboardAwareCupertinoModalPopup<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x6604040F),
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (context) => KeyboardAwareModalWrapper(child: child),
    );
  }
}

/// A wrapper widget that adds keyboard-aware padding to modal content
class KeyboardAwareModalWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardAwareModalWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: child,
    );
  }
}
