
import 'package:flutter/material.dart';

class TimeBlock extends StatelessWidget {
  final Duration duration;
  const TimeBlock({super.key,required this.duration});

  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: const EdgeInsets.only(left: 50,right: 50,bottom: 20),
      color: Colors.red.shade300,
      child: SizedBox(
          width: 500,
          height: 0.4 * MediaQuery.sizeOf(context).height,
          child: Center(
            child: Text(
            duration.toString().substring(2,7),
            style: const TextStyle(
              fontSize: 50,
            ),
            ),
          )
      ),
    );
  }
}
