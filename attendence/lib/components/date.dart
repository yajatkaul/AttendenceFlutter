import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String date;
  final String totalStudents, presentStudents;
  const DateCard(
      {super.key,
      required this.date,
      required this.totalStudents,
      required this.presentStudents});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.date_range,
          size: 45,
        ),
        Text(
          date,
          style: TextStyle(fontSize: 38),
        ),
        const SizedBox(
          width: 90,
        ),
        Text(
          "$totalStudents/$presentStudents",
          style: TextStyle(fontSize: 24),
        )
      ],
    );
  }
}
