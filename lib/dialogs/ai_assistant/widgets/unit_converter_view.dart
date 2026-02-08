import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_loading_indicator.dart';
import 'package:ai_cook_project/services/unit_converter_service.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnitConverterView extends StatefulWidget {
  const UnitConverterView({super.key});

  @override
  State<UnitConverterView> createState() => _UnitConverterViewState();
}

class _UnitConverterViewState extends State<UnitConverterView> {
  final _amountController = TextEditingController();
  final _unitController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _unitController.dispose();
    _ingredientController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(UnitConverterService service) {
    if (_amountController.text.trim().isNotEmpty &&
        _unitController.text.trim().isNotEmpty) {
      _focusNode.unfocus();
      service.convert(
        amount: _amountController.text,
        fromUnit: _unitController.text,
        ingredient:
            _ingredientController.text.isNotEmpty
                ? _ingredientController.text
                : null,
      );
    }
  }

  void _quickConvert(UnitConverterService service, String amount, String unit) {
    _amountController.text = amount;
    _unitController.text = unit;
    service.convert(amount: amount, fromUnit: unit);
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.inter(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.button.withValues(alpha: 0.5),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UnitConverterService(),
      child: Consumer<UnitConverterService>(
        builder: (context, service, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
              ),

              // Input section
              _buildSectionLabel(context, 'Measurement'),
              _buildMeasurementRow(context, service),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),

              _buildSectionLabel(context, 'Ingredient (optional)'),
              _buildIngredientRow(context, service),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
              ),

              // Results or placeholder
              if (service.isLoading)
                _buildLoading(context)
              else if (service.error != null)
                _buildError(context, service.error!)
              else if (service.hasResult)
                _buildResults(context, service.result!)
              else
                _buildPlaceholder(context, service),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.background.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.arrow_right_arrow_left_square,
            color: Colors.white,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.7),
                  AppColors.background,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
          child: Text(
            'Unit Converter',
            style: AppTextStyles.casta(
              fontSize:
                  ResponsiveUtils.fontSize(context, ResponsiveFontSize.title) *
                  1.2,
              fontWeight: AppFontWeights.bold,
              color: AppColors.white,
              letterSpacing: 0.8,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),
        Text(
          'Convert cooking measurements with precision',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.button.withValues(alpha: 0.6),
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMeasurementRow(
    BuildContext context,
    UnitConverterService service,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildInputField(
            context,
            controller: _amountController,
            focusNode: _focusNode,
            hint: 'Amount',
            icon: CupertinoIcons.number,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmit: () => _onSubmit(service),
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)),
        Expanded(
          flex: 3,
          child: _buildInputField(
            context,
            controller: _unitController,
            hint: 'Unit (cup, tbsp, g)',
            icon: CupertinoIcons.arrow_right_arrow_left,
            onSubmit: () => _onSubmit(service),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientRow(
    BuildContext context,
    UnitConverterService service,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildInputField(
            context,
            controller: _ingredientController,
            hint: 'For weight conversions',
            icon: CupertinoIcons.leaf_arrow_circlepath,
            onSubmit: () => _onSubmit(service),
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)),
        Material(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
          ),
          child: InkWell(
            onTap: service.isLoading ? null : () => _onSubmit(service),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),
              child: Icon(
                CupertinoIcons.sparkles,
                color: AppColors.white,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    FocusNode? focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    required VoidCallback onSubmit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.inter(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          fontWeight: AppFontWeights.regular,
          color: AppColors.button,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.background.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.background.withValues(alpha: 0.4),
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
        ),
        onSubmitted: (_) => onSubmit(),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const AILoadingIndicator(
      message: 'Converting measurements',
      accentColor: AppColors.background,
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: AppColors.background.withValues(alpha: 0.6),
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                color: AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, UnitConverterService service) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.arrow_right_arrow_left_square,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          color: AppColors.background.withValues(alpha: 0.3),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        _buildSectionLabel(context, 'Quick conversions'),
        Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          alignment: WrapAlignment.center,
          children: [
            _buildQuickChip(context, service, '1', 'cup'),
            _buildQuickChip(context, service, '2', 'tbsp'),
            _buildQuickChip(context, service, '100', 'grams'),
            _buildQuickChip(context, service, '1', 'oz'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickChip(
    BuildContext context,
    UnitConverterService service,
    String amount,
    String unit,
  ) {
    return GestureDetector(
      onTap: () => _quickConvert(service, amount, unit),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          border: Border.all(
            color: AppColors.background.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          '$amount $unit',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.medium,
            color: AppColors.background.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, ConversionResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, 'Conversions for ${result.original}'),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),

        // Conversions grid
        Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          children:
              result.conversions
                  .map((c) => _buildConversionCard(context, c))
                  .toList(),
        ),

        // Tip section
        if (result.tip.isNotEmpty) ...[
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Container(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lightYellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.lightbulb_fill,
                  color: AppColors.orange,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.sm,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                Expanded(
                  child: Text(
                    result.tip,
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      fontWeight: AppFontWeights.regular,
                      color: AppColors.background.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConversionCard(BuildContext context, ConvertedMeasurement conv) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.03),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conv.measurement,
            style: AppTextStyles.casta(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.bold,
              color: AppColors.background,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.sm,
              ),
              vertical:
                  ResponsiveUtils.spacing(context, ResponsiveSpacing.xs) / 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.sm,
                ),
              ),
            ),
            child: Text(
              conv.unitType,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.xs,
                ),
                fontWeight: AppFontWeights.medium,
                color: AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
