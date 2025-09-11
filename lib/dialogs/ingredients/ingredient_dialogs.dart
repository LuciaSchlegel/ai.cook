import 'package:ai_cook_project/dialogs/ingredients/logic/build_ing_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/utils/modal_utils.dart';
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
    ('📱 Showing as bottom sheet for iPhone'); // Debug
    return ModalUtils.showKeyboardAwareModalBottomSheet(
      context: context,
      enableDrag: false,
      child: dialogContent,
    );
  } else {
    ('📱 Showing as popup dialog for iPad'); // Debug
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => ResponsiveBuilder(
            builder: (context, deviceType) {
              final maxWidth = switch (deviceType) {
                DeviceType.iPhone => 350.0, // Shouldn't happen but just in case
                DeviceType.iPadMini => 500.0,
                DeviceType.iPadPro => 600.0,
              };

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
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
              final maxWidth = switch (deviceType) {
                DeviceType.iPhone => 400.0, // Shouldn't happen but just in case
                DeviceType.iPadMini => 500.0,
                DeviceType.iPadPro => 600.0,
              };

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: const AddGlobalIngDialog(),
                ),
              );
            },
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

    return ModalUtils.showKeyboardAwareModalBottomSheet(
      context: context,
      enableDrag: false,
      child: PopScope(
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
          (context) => CupertinoAlertDialog(
            title: Container(
              margin: const EdgeInsets.only(bottom: DialogConstants.spacingSM),
              child: const Text(
                'Delete Ingredient',
                style: TextStyle(
                  fontSize: DialogConstants.fontSizeXXL,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            content: Text(
              'Are you sure you want to delete $ingredientName?',
              style: const TextStyle(
                fontSize: DialogConstants.fontSizeMD,
                color: AppColors.button,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.button,
                    fontWeight: FontWeight.w500,
                    fontSize: DialogConstants.fontSizeMD,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: onDelete,
                isDestructiveAction: true,
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: DialogConstants.fontSizeMD,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
