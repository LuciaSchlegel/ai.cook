import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String hintText;
  final VoidCallback? onClear;
  final bool autoFocus;
  final bool isMenuOpen;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
    this.onClear,
    this.autoFocus = false,
    this.isMenuOpen = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final searchBarRadius = ResponsiveUtils.borderRadius(
          context,
          ResponsiveBorderRadius.xl,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(searchBarRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.md,
                      ),
                      offset: Offset(
                        0,
                        ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xxs,
                            ) *
                            1.5,
                      ),
                    ),
                  ],
                ),
                child: Padding(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ResponsiveIcon(
                        Icons.search_rounded,
                        size: ResponsiveIconSize.md,
                        color: AppColors.button.withOpacity(0.85),
                      ),
                      ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xs),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          onChanged: widget.onChanged,
                          autofocus: widget.autoFocus,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                ResponsiveFontSize.md,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.xs,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.controller.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            widget.controller.clear();
                            widget.onClear?.call();
                            if (widget.onChanged != null) {
                              widget.onChanged!('');
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.xxs,
                              ),
                            ),
                            child: ResponsiveIcon(
                              Icons.close_rounded,
                              size: ResponsiveIconSize.sm,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
