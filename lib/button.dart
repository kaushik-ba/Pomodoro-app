import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  const Button({super.key,required this.onPressed,required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white,
      elevation: 10,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(buttonName,style: const TextStyle(color: Colors.black)),
    );
  }
}
