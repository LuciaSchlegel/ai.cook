import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SafeConstrainedDialog extends StatelessWidget {
  final Widget child;
  final double maxHeightFactor;
  final double minHeight;
  final EdgeInsets insetPadding;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const SafeConstrainedDialog({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.90,
    this.minHeight = 280,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: DialogConstants.spacingMD,
    ),
    this.backgroundColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Altura segura: pantalla - safeAreas - teclado
    final usableHeight =
        mq.size.height -
        mq.padding.top -
        mq.padding.bottom -
        mq.viewInsets.bottom;

    final maxH = (usableHeight * maxHeightFactor).clamp(
      minHeight,
      mq.size.height - mq.padding.vertical,
    );

    return Dialog(
      insetPadding: insetPadding,
      backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
          ),
      clipBehavior: Clip.antiAlias, // evita que algo “sangre” fuera del radio
      child: SafeArea(
        top: true,
        bottom: true,
        // Importantísimo: evitá que hijos vuelvan a aplicar viewInsets
        child: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH.toDouble()),
            child: child, // dentro poné tu SingleChildScrollView o ListView
          ),
        ),
      ),
    );
  }
}
