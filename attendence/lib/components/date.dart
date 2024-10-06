import 'package:attendence/page/date_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final String id;
  final String date;
  final String totalStudents, presentStudents;
  const DateCard(
      {super.key,
      required this.date,
      required this.totalStudents,
      required this.presentStudents,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DatePage(
                      id: id,
                    )),
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
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(date)!),
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
