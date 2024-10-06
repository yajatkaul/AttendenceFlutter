import 'package:attendence/page/date_page.dart';
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
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DatePage()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.date_range,
                  size: 45,
                  color: Colors.black,
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 38, color: Colors.black),
                ),
              ],
            ),
            Text(
              "$presentStudents/$totalStudents",
              style: const TextStyle(fontSize: 24, color: Colors.black),
            )
          ],
        ));
  }
}
