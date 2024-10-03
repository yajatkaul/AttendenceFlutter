import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  final String name;
  const Users({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Image.network(
          'https://avatar.iran.liara.run/public/boy?username=Scott', // Example placeholder image
          width: 70,
          height: 70,
        ),
        SizedBox(
          width: 10,
        ),
        Text(name, style: TextStyle(fontSize: 24))
      ],
    );
  }
}
