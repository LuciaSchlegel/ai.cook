import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.width * 0.14,
          height: size.height * 0.35,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.white.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.009),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/icons/nut_assist.png',
                  width: 51,
                  height: 51,
                ),
                _buildNutritionCard('Protein', 0.5, Icons.food_bank_rounded),
                _buildNutritionCard('Carbs', 0.5, Icons.food_bank_rounded),
                _buildNutritionCard('Fats', 0.5, Icons.food_bank_rounded),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon(
                    //   CupertinoIcons.chevron_down,
                    //   size: 12,
                    //   color: CupertinoColors.black,
                    // ),
                    Icon(
                      CupertinoIcons.question_circle,
                      size: 12,
                      color: CupertinoColors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildNutritionCard(String title, double value, IconData icon) {
  return Column(
    children: [
      SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          value: value,
          color: AppColors.mutedGreen,
          backgroundColor: AppColors.lightYellow,
          strokeWidth: 3.5,
        ),
      ),
      SizedBox(height: 6),
      Icon(icon, size: 12),
      SizedBox(height: 2),
      Text(
        title,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: AppColors.button,
        ),
      ),
    ],
  );
}
