import 'package:flutter/material.dart';

class UsersPresent extends StatefulWidget {
  final String name;
  final ValueChanged<bool> onPresentChanged;

  const UsersPresent({
    super.key,
    required this.name,
    required this.onPresentChanged,
  });

  @override
  _UsersPresentState createState() => _UsersPresentState();
}

class _UsersPresentState extends State<UsersPresent> {
  bool present = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Image.network(
          "https://avatar.iran.liara.run/public/boy?username=${widget.name}",
          width: 70,
          height: 70,
        ),
        const SizedBox(width: 10),
        Text(widget.name, style: const TextStyle(fontSize: 24)),
        Checkbox(
          value: present,
          onChanged: (bool? newValue) {
            setState(() {
              present = newValue ?? false;
            });
            // Call the parent's callback function to pass the state back
            widget.onPresentChanged(present);
          },
        ),
      ],
    );
  }
}
