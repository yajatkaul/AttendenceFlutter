import 'dart:convert';
import 'package:attendence/components/date.dart';
import 'package:attendence/components/user.dart';
import 'package:attendence/page/add_date.dart';
import 'package:attendence/page/add_newuser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerUsers = ScrollController();

  List<dynamic> _dates = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;

  List<dynamic> _users = [];
  int _currentPageUsers = 1;
  bool _isLoadingUsers = false;
  bool _hasMoreUsers = true;

  DateTime? _selectedDate;
  DateTime? _selectedFinalDate;

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

  void _onScrollUsers() {
    if (_scrollControllerUsers.position.pixels ==
        _scrollControllerUsers.position.maxScrollExtent) {
      _fetchDataUsers(); // Fetch more users
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchDataUsers();
    _scrollController.addListener(_onScroll);
    _scrollControllerUsers.addListener(_onScrollUsers);
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Build the base URL
    String url =
        "http://192.168.1.7:5000/api/data/dates?page=$_currentPage&limit=$_limit";

    // Add start_date and end_date if they are selected
    if (_selectedDate != null) {
      String startDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      url += "&start_date=$startDateStr";
    }
    if (_selectedFinalDate != null) {
      String endDateStr = DateFormat('yyyy-MM-dd').format(_selectedFinalDate!);
      url += "&end_date=$endDateStr";
    }

    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newDates = jsonDecode(response.body);
        print('Received ${newDates.length} dates');

        setState(() {
          _dates.addAll(newDates);
          _currentPage++;
          _isLoading = false;

          // Check if more data is available
          if (newDates.length < _limit) {
            _hasMore = false;
            print('No more dates to load');
          }
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchDataUsers() async {
    if (_isLoadingUsers || !_hasMoreUsers) {
      return;
    }

    setState(() {
      _isLoadingUsers = true;
    });

    final url =
        "http://192.168.1.7:5000/api/data/getUsers?page=$_currentPageUsers&limit=$_limit";
    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newUsers = jsonDecode(response.body);
        print('Received ${newUsers.length} users');

        setState(() {
          _users.addAll(newUsers);
          _currentPageUsers++;

          // Check if there are more users to load
          if (newUsers.length < _limit || newUsers.isEmpty) {
            _hasMoreUsers = false;
            print('No more users to load');
          }

          _isLoadingUsers = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingUsers = false;
      });
      print('Error fetching data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now(), // Use previously selected date or current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // Reset pagination and data variables
        _dates.clear();
        _currentPage = 1;
        _hasMore = true;
      });
      // Fetch new data
      _fetchData();
    }
  }

  Future<void> _selectFinalDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFinalDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedFinalDate = picked;
        // Reset pagination and data variables
        _dates.clear();
        _currentPage = 1;
        _hasMore = true;
      });
      // Fetch new data
      _fetchData();
    }
  }

  Future<void> _deleteUser(id) async {
    // Define your API URL
    String apiUrl = 'http://192.168.1.7:5000/api/data/deleteUser/$id';

    try {
      // Send the DELETE request (consider using http.delete instead of http.get)
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('User deleted successfully');

        // Clear and reset user data
        setState(() {
          _users.clear();
          _currentPageUsers = 1;
          _hasMoreUsers = true;
          _isLoadingUsers = true;
        });

        // Fetch updated user data
        await _fetchDataUsers();

        // Reset loading state
        setState(() {
          _isLoadingUsers = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      print('Failed to send data: $e');
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'Start Date',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectFinalDate(context),
                    child: Text(
                        _selectedFinalDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(_selectedFinalDate!)
                            : 'Final Date',
                        style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        _dates.clear();
                        _currentPage = 1;
                        _hasMore = true;
                      });
                      _fetchData();
                    },
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _dates.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _dates.length) {
                      final dates = _dates[index];
                      return Column(children: [
                        DateCard(
                          date: dates['date'] ?? "",
                          totalStudents: dates["total"] ?? "",
                          presentStudents: dates["present"] ?? "",
                          id: dates["_id"],
                        ),
                        const SizedBox(height: 10),
                      ]);
                    } else if (_hasMore) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
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
                onTap: () => _navigateAndRefreshDates(context),
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
      Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            controller: _scrollControllerUsers,
            itemCount: _users.length + (_hasMoreUsers ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _users.length) {
                final user = _users[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Users(
                      name: user['displayName'] ?? "",
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _deleteUser(user["_id"]);
                        await _fetchDataUsers();
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              } else if (_isLoadingUsers) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
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
                onTap: () => _navigateAndRefresh(context),
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateAndRefresh(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUser()),
    );

    // If the result is true, it means a date was added, so we refresh the data
    if (result == true) {
      _users.clear(); // Clear existing dates
      _currentPageUsers = 1; // Reset pagination
      _hasMoreUsers = true; // Reset hasMore
      _fetchDataUsers(); // Fetch the new data
    }
  }

  Future<void> _navigateAndRefreshDates(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDate()),
    );

    // If the result is true, it means a date was added, so we refresh the data
    if (result == true) {
      _dates.clear(); // Clear existing dates
      _currentPage = 1; // Reset pagination for dates
      _hasMore = true; // Reset hasMore for dates
      _fetchData(); // Fetch the new dates data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Manager'),
      ),
      body: _widgetOptions(context).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Users',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
