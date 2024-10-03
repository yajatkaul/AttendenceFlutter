import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String date;
  const DateCard({super.key, required this.date});

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
        )
      ],
    );
  }
}
