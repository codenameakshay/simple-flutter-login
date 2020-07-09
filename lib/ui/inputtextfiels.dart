import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({
    Key key,
    @required this.myController,
    @required this.text,
    @required this.icon,
    @required this.initialText,
  }) : super(key: key);

  final TextEditingController myController;
  final String text;
  final IconData icon;
  final String initialText;

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  void initState() {
    widget.myController.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
            colors: [
              Color(0xff1E4746).withOpacity(0.1),
              Color(0xff70D9D6).withOpacity(0.1)
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: TextField(
          controller: widget.myController,
          decoration: InputDecoration(
            fillColor: Colors.red,
            labelText: widget.text,
            labelStyle: TextStyle(
              fontFamily: "Noto Sans",
              color: Color(0xFF1E5C5A),
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: Icon(
              widget.icon,
              color: Color(0xFF1E5C5A),
            ),
          ),
        ),
      ),
    );
  }
}
