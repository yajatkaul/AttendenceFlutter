import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New User'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                  decoration: InputDecoration(
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
                  onTap: () {},
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
