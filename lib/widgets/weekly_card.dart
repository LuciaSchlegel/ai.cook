import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class WeeklyCard extends StatefulWidget {
  const WeeklyCard({super.key});

  @override
  State<WeeklyCard> createState() => _WeeklyCardState();
}

class _WeeklyCardState extends State<WeeklyCard> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: _SampleCard(
        title: 'my weekly cooking',
        description: 'This is a sample',
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      height: size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.03,
              bottom: size.height * 0.01,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w600,
                fontFamily: 'Casta',
                color: AppColors.black,
              ),
            ),
          ),
          const WeekDayProgress(),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.02),
              child: InnerCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekDayProgress extends StatelessWidget {
  const WeekDayProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Map<String, dynamic>> weekDays = [
      {'day': 'M', 'isActive': true},
      {'day': 'T', 'isActive': true},
      {'day': 'W', 'isActive': true},
      {'day': 'T', 'isActive': false},
      {'day': 'F', 'isActive': true},
      {'day': 'S', 'isActive': false},
      {'day': 'S', 'isActive': false},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            weekDays
                .map(
                  (day) =>
                      _DayCircle(day: day['day'], isActive: day['isActive']),
                )
                .toList(),
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.day, this.isActive = false});

  final String day;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.08;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.mutedGreen : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: size.width * 0.035,
          ),
        ),
      ),
    );
  }
}

class InnerCard extends StatelessWidget {
  const InnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'today\'s meal plan...',
              style: TextStyle(
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.w500,
                fontFamily: 'Casta',
                color: AppColors.black,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Divider(color: Colors.black, thickness: 1),
          ],
        ),
      ),
    );
  }
}
