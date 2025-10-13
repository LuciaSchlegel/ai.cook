import 'package:ai_cook_project/dialogs/ingredients/logic/build_ing_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/add_global_ing_dialog.dart';

/// Shows ingredient dialog with responsive design
/// - iPhone: Modal bottom sheet
/// - iPad: Centered popup dialog
Future<void> showResponsiveIngredientDialog({
  required BuildContext context,
  required List<Category> categories,
  required List<UserIng> ingredients,
  required Map<int, UserIng> userIngredients,
  required Future<void> Function(UserIng) onSave,
  Function()? onDelete,
  UserIng? userIng,
}) {
  final deviceType = ResponsiveUtils.getDeviceType(context);
  ('🔍 Ingredient dialog - Device type: $deviceType'); // Debug

  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );

  final isPopupMode = deviceType != DeviceType.iPhone;

  final dialogContent = PopScope(
    canPop: true,
    child: buildIngredientDialog(
      userIng: userIng,
      onDelete: onDelete,
      context: context,
      categories: categories,
      ingredientsProvider: ingredientsProvider,
      onSave: onSave,
      isPopup: isPopupMode, // Pass popup mode based on device type
    ),
  );

  if (deviceType == DeviceType.iPhone) {
    ('📱 Showing as responsive bottom sheet for iPhone'); // Debug
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true, // Let the dialog handle its own safe areas
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      builder:
          (context) => SafeArea(
            // Respect top safe area when keyboard pushes content up
            top: true,
            bottom: false, // Let modal handle its own bottom padding
            child: Padding(
              // Only handle keyboard padding outside the modal
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: _KeyboardAwareModalContent(
                isKeyboardVisible: MediaQuery.of(context).viewInsets.bottom > 0,
                child: dialogContent,
              ),
            ),
          ),
    );
  } else {
    ('📱 Showing as popup dialog for iPad'); // Debug
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => ResponsiveBuilder(
            builder: (context, deviceType) {
              // Use responsive optimal content width instead of hardcoded values
              final maxWidth = ResponsiveUtils.getOptimalContentWidth(context);

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        ResponsiveUtils.getModalConfig(context).maxSize,
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: dialogContent,
                  ),
                ),
              );
            },
          ),
    );
  }
}

/// Shows add global ingredient dialog with responsive design
/// - iPhone: Regular dialog (already centered)
/// - iPad: Constrained width popup dialog
Future<void> showResponsiveAddGlobalIngDialog(BuildContext context) {
  final deviceType = ResponsiveUtils.getDeviceType(context);
  ('🔍 Add Global Ing dialog - Device type: $deviceType'); // Debug

  if (deviceType == DeviceType.iPhone) {
    ('📱 Showing regular dialog for iPhone'); // Debug
    return showDialog(
      context: context,
      builder: (_) => const AddGlobalIngDialog(),
    );
  } else {
    ('📱 Showing constrained dialog for iPad'); // Debug
    return showDialog(
      context: context,
      builder:
          (context) => ResponsiveBuilder(
            builder: (context, deviceType) {
              // Use responsive optimal content width for consistency
              final maxWidth = ResponsiveUtils.getOptimalContentWidth(context);

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        ResponsiveUtils.getModalConfig(context).maxSize,
                  ),
                  child: const AddGlobalIngDialog(),
                ),
              );
            },
          ),
    );
  }
}

/// Widget that handles modal appearance when keyboard is visible
class _KeyboardAwareModalContent extends StatelessWidget {
  final bool isKeyboardVisible;
  final Widget child;

  const _KeyboardAwareModalContent({
    required this.isKeyboardVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(20),
          // Add bottom radius when keyboard is visible
          bottom: isKeyboardVisible ? const Radius.circular(20) : Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(20),
          bottom: isKeyboardVisible ? const Radius.circular(20) : Radius.zero,
        ),
        child: child,
      ),
    );
  }
}

class IngredientDialogs {
  Future<void> showIngredientDialog({
    required BuildContext context,
    required List<Category> categories,
    required List<UserIng> ingredients,
    required Map<int, UserIng> userIngredients,
    required Future<void> Function(UserIng) onSave,
    Function()? onDelete,
    UserIng? userIng,
  }) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    return ResponsiveModalBottomSheet.show(
      context: context,
      isDismissible: true,
      enableDrag: false,
      builder:
          (context, scrollController) => PopScope(
            canPop: true,
            child: buildIngredientDialog(
              userIng: userIng,
              onDelete: onDelete,
              context: context,
              categories: categories,
              ingredientsProvider: ingredientsProvider,
              onSave: onSave,
            ),
          ),
    );
  }

  static void showDeleteDialog({
    required BuildContext context,
    required String ingredientName,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => ResponsiveBuilder(
            builder:
                (context, deviceType) => CupertinoAlertDialog(
                  title: Container(
                    margin: ResponsiveUtils.verticalPadding(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                    child: Text(
                      'Delete Ingredient',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.xxl,
                        ),
                        fontFamily: 'Casta',
                        color: AppColors.button,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete $ingredientName?',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.button,
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.button,
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.md,
                          ),
                        ),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: onDelete,
                      isDestructiveAction: true,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.md,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}
