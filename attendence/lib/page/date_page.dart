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
  List<dynamic> _filteredData = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPresentData();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  // This method is called whenever the text in the search field changes
  void _onSearchTextChanged() {
    String searchText = _searchController.text.toLowerCase();

    setState(() {
      if (searchText.isEmpty) {
        _filteredData = _presentData;
      } else {
        _filteredData = _presentData.where((item) {
          String displayName = item['displayName'].toString().toLowerCase();
          return displayName.startsWith(searchText);
        }).toList();
      }
    });
  }

  Future<void> fetchPresentData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.7:5000/api/data/getPresent/${widget.id}'));

      if (response.statusCode == 200) {
        // Parse the JSON response as a map
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Assuming the list of data is stored in a field called 'users' in the JSON
        final List<dynamic> data = responseData['users'] as List<dynamic>;
        print(data);

        setState(() {
          _presentData = data[0];
          _filteredData = data[0]; // Initialize filtered data with all data
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
          : Column(
              children: [
                // Add the TextField at the top
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Search',
                      hintText: 'Enter name',
                      prefixIcon: Icon(Icons.search),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                // Use Expanded to fill the remaining space
                Expanded(
                  child: _filteredData.isEmpty
                      ? const Center(
                          child: Text(
                              'No data available')) // Show message if no data is returned
                      : ListView.builder(
                          itemCount: _filteredData.length,
                          itemBuilder: (context, index) {
                            final item =
                                _filteredData[index]; // Access the JSON object

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                children: [
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
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
