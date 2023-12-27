import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customLoading extends StatelessWidget {
  const customLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator());
  }
}
