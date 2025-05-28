import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class IngredientsCard extends StatelessWidget {
  const IngredientsCard({super.key});

  static const List<Map<String, dynamic>> _sampleIngredients = [
    {'name': 'Eggs', 'lowStock': true},
    {'name': 'Milk', 'lowStock': false},
    {'name': 'Flour', 'lowStock': true},
    {'name': 'Sugar', 'lowStock': false},
    {'name': 'Butter', 'lowStock': true},
    // {'name': 'Vanilla Extract', 'lowStock': false},
    // {'name': 'Baking Powder', 'lowStock': false},
    // {'name': 'Salt', 'lowStock': false},
    // {'name': 'Pepper', 'lowStock': false},
    // {'name': 'Garlic', 'lowStock': true},
    // {'name': 'Onion', 'lowStock': false},
    // {'name': 'Tomato', 'lowStock': false},
    // {'name': 'Cheese', 'lowStock': false},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'my\ningredients',
          //   style: TextStyle(
          //     fontFamily: 'Casta',
          //     fontSize: 42,
          //     color: Colors.white,
          //     height: 0.9,
          //     letterSpacing: 0.8,
          //   ),
          // ),
          SizedBox(height: 24),
          Card.filled(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: AppColors.mutedGreen,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'my last ingredients',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Casta',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: size.width * 0.8, // Width of the divider
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white,
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    constraints: BoxConstraints(maxHeight: size.height * 0.4),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: _sampleIngredients.length,
                      separatorBuilder:
                          (context, index) =>
                              SizedBox(height: size.height * 0.02),
                      itemBuilder: (context, index) {
                        final ingredient = _sampleIngredients[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ingredient['name'],
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (ingredient['lowStock'])
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 20,
                                    color: Colors.amber[600],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
