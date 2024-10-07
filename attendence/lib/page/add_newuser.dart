import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();

    Future<void> _sendData() async {
      final String displayName = _nameController.text;

      if (displayName.isEmpty) {
        // You can show a message or validation if the name is empty
        return;
      }

      // Define your API URL
      const String apiUrl = 'http://82.112.238.10:9000/api/data/createUsers';

      // Create the JSON payload
      final Map<String, dynamic> data = {
        'displayName': displayName,
      };

      try {
        // Send the POST request
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Success, handle the response as needed
          print('User created successfully');
          Navigator.pop(context, true);
        } else {
          // Handle errors
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any exceptions
        print('Failed to send data: $e');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('New User'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)))),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: _sendData,
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
