import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showDraggableModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  bool isDismissible = true,
  bool enableDrag = true,
  double minChildSize = 0.45,
  double initialChildSize = 0.72,
  double maxChildSize = 0.95,
  List<double>? snapSizes, // e.g. [0.45, 0.72, 0.95]
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (ctx) {
      final mq = MediaQuery.of(ctx);
      return Padding(
        // Empuja el sheet cuando aparece el teclado (sin duplicar paddings)
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          minChildSize: minChildSize,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          snap: true,
          snapSizes: snapSizes ?? const [0.45, 0.72, 0.95],
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Material(
                color: CupertinoColors.systemBackground,
                child: builder(ctx, scrollController),
              ),
            );
          },
        ),
      );
    },
  );
}
