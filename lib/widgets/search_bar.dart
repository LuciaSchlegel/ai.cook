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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: isSmallScreen ? 44 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.button.withOpacity(0.85),
                  size: isSmallScreen ? 20 : 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    autofocus: widget.autoFocus,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.5 : 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isSmallScreen ? 14.5 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                if (widget.controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      widget.onClear?.call();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey[600],
                      size: isSmallScreen ? 20 : 22,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
