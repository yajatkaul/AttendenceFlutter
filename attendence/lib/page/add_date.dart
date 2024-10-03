import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class AddDate extends StatefulWidget {
  @override
  _AddDateState createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {
  DateTime? selectedDate; // Nullable DateTime to hold the selected date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Show the date picker dialog when the button is pressed
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate =
                        pickedDate; // Save the selected date and refresh the UI
                  });
                }
              },
              child: Text(
                selectedDate == null
                    ? 'Select Date' // If no date is selected, display this
                    : "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
