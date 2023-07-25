
import 'package:flutter/material.dart';

class RoundElevatedButton extends StatelessWidget {

  final String text;
  final bool loading;
  final VoidCallback onPressed;
  RoundElevatedButton({required this.text,
     this.loading=false,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: onPressed,
        child: loading?CircularProgressIndicator() :Text(text),
    );
  }
}


