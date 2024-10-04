import 'dart:convert';
import 'package:attendence/components/date.dart';
import 'package:attendence/components/user.dart';
import 'package:attendence/page/add_date.dart';
import 'package:attendence/page/add_newuser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<dynamic> _dates = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 20;

  List<dynamic> _users = [];
  int _currentPageUsers = 1;
  bool _isLoadingUsers = false;
  bool _hasMoreUsers = true;

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

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchDataUsers();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        "http://192.168.1.9:5000/api/data/dates?page=$_currentPage&limit=$_limit";
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

          // If fewer papers are returned than the limit, it means there's no more data
          if (newDates.length < _limit) {
            _hasMore = false;
            print('No more dates to load');
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

  Future<void> _fetchDataUsers() async {
    if (_isLoadingUsers || !_hasMoreUsers) {
      return;
    }

    setState(() {
      _isLoadingUsers = true;
    });

    final url =
        "http://192.168.1.9:5000/api/data/getUsers?page=$_currentPageUsers&limit=$_limit";
    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newUsers = jsonDecode(response.body);
        print('Received ${newUsers.length} users');

        setState(() {
          _users.addAll(newUsers);
          _currentPageUsers++;
          _isLoadingUsers = false;

          // If fewer papers are returned than the limit, it means there's no more data
          if (newUsers.length < _limit) {
            _hasMoreUsers = false;
            print('No more users to load');
          }
        });
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoadingUsers = false;
      });
      print('Error fetching data: $e');
    }
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: _dates.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _dates.length) {
                final dates = _dates[index];
                return Column(children: [
                  DateCard(
                    date: dates['date'] ?? "",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDate()),
                  );
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
          /*const Column(
            children: [
              DateCard(
                date: "2012-3-2",
              ),
            ],
          )*/
        ],
      ),
      Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: _users.length + (_hasMoreUsers ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _users.length) {
                final users = _users[index];
                return Column(children: [
                  Users(
                    name: users['displayName'] ?? "",
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
                return const SizedBox(); // Return an empty widget when there are no more items
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddUser()), // Navigate to AddDate page
                  );
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            ),
          ),
          /*Column(
            children: [
              Users(name: "Name1"),
            ],
          )*/
        ],
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
