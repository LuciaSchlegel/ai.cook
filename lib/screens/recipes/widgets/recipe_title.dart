import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class RecipeTitle extends StatelessWidget {
  final String name;

  const RecipeTitle({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final text = name;
        final words = text.split(' ');

        String line1 = '';
        String line2 = '';

        if (words.length == 1) {
          line1 = text;
        } else {
          int splitIndex = (words.length / 2).ceil();
          line1 = words.take(splitIndex).join(' ');
          line2 = words.skip(splitIndex).join(' ');
        }

        final availableWidth = constraints.maxWidth * 0.95;
        final textStyle = _calculateTextStyle(words);

        return Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: availableWidth,
                child: Text(
                  line1,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (line2.isNotEmpty) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: availableWidth,
                  child: Text(
                    line2,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  TextStyle _calculateTextStyle(List<String> words) {
    const int longWordThreshold = 12;
    const double baseFontSize = 34.0;
    const double scaleFactor = 0.9;

    bool hasLongWord = words.any((word) => word.length > longWordThreshold);
    return TextStyle(
      fontSize: hasLongWord ? baseFontSize * scaleFactor : baseFontSize,
      height: 1.1,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w600,
      fontFamily: 'Casta',
      color: AppColors.button,
    );
  }
}
