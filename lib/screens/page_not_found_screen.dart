import 'package:flutter/material.dart';
import 'package:dwarfurl/constants.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(k404),
      ),
    );
  }
}
