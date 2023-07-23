import 'package:flutter/material.dart';

class CustomeTextField extends StatefulWidget {
  final String txt;

  const CustomeTextField({key, required this.txt}) : super(key: key);
  @override
  _CustomeTextFieldState createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30)),
      child: Center(),
    );
  }
}
