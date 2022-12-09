import 'package:flutter/material.dart';

class StatusText extends StatefulWidget {
  final String? text;
  const StatusText({Key? key, required this.text}) : super(key: key);

  @override
  _StatusTextState createState() => _StatusTextState();
}

class _StatusTextState extends State<StatusText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text!,
      style: TextStyle(
        color: widget.text == "Waiting for review" ||
                widget.text == "Waiting for Confirmation"
            ? Colors.lightBlue
            : widget.text == "Success"
                ? Colors.greenAccent
                : Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
