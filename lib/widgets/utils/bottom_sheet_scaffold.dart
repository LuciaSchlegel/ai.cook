import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showDraggableModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  bool isDismissible = true,
  bool enableDrag = true,
  double? minChildSize,
  double? initialChildSize,
  double? maxChildSize,
  List<double>? snapSizes,
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

      // Get responsive values
      final screenWidth = mq.size.width;
      final responsiveMinSize =
          minChildSize ??
          (screenWidth < DialogConstants.mobileBreakpoint ? 0.5 : 0.45);
      final responsiveInitialSize =
          initialChildSize ??
          (screenWidth < DialogConstants.mobileBreakpoint ? 0.75 : 0.72);
      final responsiveMaxSize =
          maxChildSize ??
          (screenWidth < DialogConstants.mobileBreakpoint ? 0.95 : 0.9);
      final responsiveSnapSizes =
          snapSizes ??
          (screenWidth < DialogConstants.mobileBreakpoint
              ? [0.5, 0.75, 0.95]
              : [0.45, 0.72, 0.9]);

      return Padding(
        // Empuja el sheet cuando aparece el teclado (sin duplicar paddings)
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          minChildSize: responsiveMinSize,
          initialChildSize: responsiveInitialSize,
          maxChildSize: responsiveMaxSize,
          snap: true,
          snapSizes: responsiveSnapSizes,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DialogConstants.radiusXL),
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
