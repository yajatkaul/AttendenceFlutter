import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  final String name;
  const Users({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Image.network(
          "https://avatar.iran.liara.run/public/boy?username=$name", // Example placeholder image
          width: 70,
          height: 70,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(name, style: const TextStyle(fontSize: 24))
      ],
    );
  }
}
