import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

class DatePage extends StatefulWidget {
  final String id;
  const DatePage({super.key, required this.id});

  @override
  _DatePageState createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  List<dynamic> _presentData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPresentData();
  }

  Future<void> fetchPresentData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.7:5000/api/data/getPresent/${widget.id}'));

      if (response.statusCode == 200) {
        // Parse the JSON response as a map
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming the list of data is stored in a field called 'data' in the JSON
        final List<dynamic> data = responseData['users'] as List<dynamic>;

        setState(() {
          _presentData = data;
          _isLoading = false;
        });
      } else {
        // Handle any error codes
        setState(() {
          _isLoading = false;
        });
        print('Failed to load data');
      }
    } catch (e) {
      // Handle any exceptions
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : _presentData.isEmpty
              ? const Center(
                  child: Text(
                      'No data available')) // Show message if no data is returned
              : ListView.builder(
                  itemCount: _presentData.length,
                  itemBuilder: (context, index) {
                    final item = _presentData[index]; // Access the JSON object

                    return Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.network(
                          "https://avatar.iran.liara.run/public/boy?username=${item["displayName"]}", // Example placeholder image
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          item["displayName"],
                          style: const TextStyle(fontSize: 24),
                        )
                      ],
                    );
                  },
                ),
    );
  }
}
