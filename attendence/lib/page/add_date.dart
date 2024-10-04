import 'dart:convert';
import 'package:attendence/components/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDate extends StatefulWidget {
  @override
  _AddDateState createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {
  DateTime? selectedDate;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _users = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        "http://192.168.1.9:5000/api/data/getUsers?page=$_currentPage&limit=$_limit";
    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newUsers = jsonDecode(response.body);
        print('Received ${newUsers.length} users');

        setState(() {
          _users.addAll(newUsers);
          _currentPage++;
          _isLoading = false;

          // If fewer papers are returned than the limit, it means there's no more data
          if (newUsers.length < _limit) {
            _hasMore = false;
            print('No more users to load');
          }
        });
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Date'),
      ),
      body: Column(
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
          const SizedBox(height: 10), // Adding spacing
          Expanded(
            // This ensures that the ListView takes available space
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _users.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _users.length) {
                  final users = _users[index];
                  return Column(
                    children: [
                      Users(
                        name: users['displayName'] ?? "",
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else if (_hasMore) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const SizedBox(); // Return an empty widget when there are no more items
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
