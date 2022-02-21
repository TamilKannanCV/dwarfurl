import 'package:flutter/material.dart';
import 'package:dwarfurl/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: Image.asset(k404),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HomeScreen.route);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    kLogo,
                    height: 70.0,
                    width: 70.0,
                  ),
                  Text(
                    "dwarfUrl",
                    style: GoogleFonts.balooBhai2(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
