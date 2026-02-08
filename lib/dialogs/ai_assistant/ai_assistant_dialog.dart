import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_feature_card.dart';
import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_assistant_header.dart';
import 'package:ai_cook_project/dialogs/ai_assistant/widgets/diet_adapter_view.dart';
import 'package:ai_cook_project/dialogs/ai_assistant/widgets/recommendations_view.dart';
import 'package:ai_cook_project/dialogs/ai_assistant/widgets/substitutions_view.dart';
import 'package:ai_cook_project/dialogs/ai_assistant/widgets/unit_converter_view.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/ai_dialog_scaffold.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/close_button.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:provider/provider.dart';

/// AI Feature types available in the assistant
enum AIFeature {
  substitutions,
  unitConversion,
  dietAdaptation,
  recommendations,
}

class AiAssistantDialog extends StatefulWidget {
  final VoidCallback onToggle;
  final bool isOpen;

  const AiAssistantDialog({
    super.key,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  State<AiAssistantDialog> createState() => _AiAssistantDialogState();
}

class _AiAssistantDialogState extends State<AiAssistantDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _apertureAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _contentScaleAnimation;

  AIFeature? _selectedFeature;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _apertureAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AiAssistantDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
        // Clear recommendations provider if it was the active feature
        if (_selectedFeature == AIFeature.recommendations) {
          Provider.of<AIRecommendationsProvider>(
            context,
            listen: false,
          ).clearAll();
        }
        setState(() => _selectedFeature = null);
      }
    }
  }

  void _handleClose() {
    widget.onToggle();
  }

  void _handleFeatureSelected(AIFeature feature) {
    setState(() => _selectedFeature = feature);
  }

  void _handleBackToGrid() {
    if (_selectedFeature == AIFeature.recommendations) {
      Provider.of<AIRecommendationsProvider>(context, listen: false).clearAll();
    }
    setState(() => _selectedFeature = null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return AiDialogScaffold(
          isOpen: widget.isOpen,
          controller: _controller,
          apertureAnimation: _apertureAnimation,
          contentOpacityAnimation: _contentOpacityAnimation,
          contentScaleAnimation: _contentScaleAnimation,
          onClose: _handleClose,
          scrollContentBuilder: (scrollController) {
            final mq = MediaQuery.of(context);

            return SafeArea(
              top: true,
              bottom: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                child: Container(
                  decoration: ResponsiveUtils.getDialogContainerDecoration(
                    context,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.xl,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Fixed header with close button
                        SizedBox(
                          height: ResponsiveUtils.getDialogTopPadding(context),
                          child: Stack(
                            children: [
                              // Back button (when feature selected)
                              if (_selectedFeature != null)
                                Positioned(
                                  top: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.sm,
                                  ),
                                  left: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.sm,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.mutedGreen.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.borderRadius(
                                          context,
                                          ResponsiveBorderRadius.md,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _handleBackToGrid,
                                      icon: Icon(
                                        CupertinoIcons.back,
                                        color: AppColors.button,
                                        size: ResponsiveUtils.iconSize(
                                          context,
                                          ResponsiveIconSize.md,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.sm,
                                ),
                                right: ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.sm,
                                ),
                                child: CloseButtonExt(
                                  handleClose: _handleClose,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Scrollable content area
                        Expanded(
                          child: CustomScrollView(
                            controller: scrollController,
                            physics: const ClampingScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: ResponsiveUtils.padding(
                                  context,
                                  ResponsiveSpacing.md,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child:
                                      _selectedFeature == null
                                          ? _buildFeatureGrid(context)
                                          : _buildFeatureView(context),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height:
                                      ResponsiveUtils.getAIDialogBottomPadding(
                                        context,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AiAssistantHeader(),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
        ),
        // Feature cards grid (2x2)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: ResponsiveUtils.spacing(
            context,
            ResponsiveSpacing.md,
          ),
          crossAxisSpacing: ResponsiveUtils.spacing(
            context,
            ResponsiveSpacing.md,
          ),
          childAspectRatio: 0.95,
          children: [
            AIFeatureCard(
              feature: AIFeature.substitutions,
              onTap: () => _handleFeatureSelected(AIFeature.substitutions),
            ),
            AIFeatureCard(
              feature: AIFeature.unitConversion,
              onTap: () => _handleFeatureSelected(AIFeature.unitConversion),
            ),
            AIFeatureCard(
              feature: AIFeature.dietAdaptation,
              onTap: () => _handleFeatureSelected(AIFeature.dietAdaptation),
            ),
            AIFeatureCard(
              feature: AIFeature.recommendations,
              onTap: () => _handleFeatureSelected(AIFeature.recommendations),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
        ),
        // Powered by AI badge
        _PoweredByAIBadge(),
      ],
    );
  }

  Widget _buildFeatureView(BuildContext context) {
    switch (_selectedFeature!) {
      case AIFeature.substitutions:
        return const SubstitutionsView();
      case AIFeature.unitConversion:
        return const UnitConverterView();
      case AIFeature.dietAdaptation:
        return const DietAdapterView();
      case AIFeature.recommendations:
        return const RecommendationsView();
    }
  }
}

/// Powered by AI badge
class _PoweredByAIBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mutedGreen.withValues(alpha: 0.1),
            AppColors.mutedGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
            ),
            decoration: BoxDecoration(
              color: AppColors.mutedGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.sm,
                ),
              ),
            ),
            child: Icon(
              CupertinoIcons.sparkles,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xs),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            'Powered by Claude AI',
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.xs,
              ),
              fontWeight: AppFontWeights.medium,
              color: AppColors.mutedGreen,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
