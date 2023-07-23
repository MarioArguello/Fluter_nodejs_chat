import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  String text = '';
  NoDataWidget({this.text = ''});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/cajavacia.png',
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
