import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_loading_indicator.dart';
import 'package:ai_cook_project/services/substitutions_service.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubstitutionsView extends StatefulWidget {
  const SubstitutionsView({super.key});

  @override
  State<SubstitutionsView> createState() => _SubstitutionsViewState();
}

class _SubstitutionsViewState extends State<SubstitutionsView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(SubstitutionsService service) {
    if (_controller.text.trim().isNotEmpty) {
      _focusNode.unfocus();
      service.generateSubstitutions(ingredient: _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubstitutionsService(),
      child: Consumer<SubstitutionsService>(
        builder: (context, service, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
              ),

              // Search input
              _buildSectionLabel(context, 'Ingredient'),
              _buildSearchInput(context, service),
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
                _buildPlaceholder(context),
            ],
          );
        },
      ),
    );
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
          color: AppColors.background.withValues(alpha: 0.5),
          letterSpacing: 0.5,
        ),
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
            CupertinoIcons.arrow_2_circlepath,
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
            'Smart Substitutions',
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
          'Find the perfect alternative for any ingredient',
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

  Widget _buildSearchInput(BuildContext context, SubstitutionsService service) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.words,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.regular,
                color: AppColors.button,
              ),
              decoration: InputDecoration(
                hintText: 'e.g., butter, eggs, milk',
                hintStyle: AppTextStyles.inter(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.regular,
                  color: AppColors.button.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.button.withValues(alpha: 0.4),
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
              ),
              onSubmitted: (_) => _onSubmit(service),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            child: Material(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              child: InkWell(
                onTap: service.isLoading ? null : () => _onSubmit(service),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    color: AppColors.white,
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.md,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const AILoadingIndicator(
      message: 'Finding substitutes',
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

  Widget _buildPlaceholder(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.lightbulb,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          color: AppColors.background.withValues(alpha: 0.3),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        _buildSectionLabel(context, 'Popular'),
        Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          alignment: WrapAlignment.center,
          children: [
            _buildSuggestionChip(context, 'Butter'),
            _buildSuggestionChip(context, 'Eggs'),
            _buildSuggestionChip(context, 'Milk'),
            _buildSuggestionChip(context, 'Flour'),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        final service = Provider.of<SubstitutionsService>(
          context,
          listen: false,
        );
        service.generateSubstitutions(ingredient: text);
      },
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
          text,
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.medium,
            color: AppColors.background.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, SubstitutionResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          context,
          'Results for "${result.originalIngredient}"',
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),

        // Substitutes list
        ...result.substitutes.map((sub) => _buildSubstituteCard(context, sub)),

        // Tips section
        if (result.tips.isNotEmpty) ...[
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
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
                    result.tips,
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

  Widget _buildSubstituteCard(BuildContext context, SubstituteOption sub) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.md,
                    ),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.arrow_right_arrow_left,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.sm,
                  ),
                  color: AppColors.background.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              Expanded(
                child: Text(
                  sub.name,
                  style: AppTextStyles.casta(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.lg,
                    ),
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.background,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
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
                  sub.ratio,
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.background.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          if (sub.notes.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            Text(
              sub.notes,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.regular,
                color: AppColors.background.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
