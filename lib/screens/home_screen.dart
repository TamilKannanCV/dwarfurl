import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwarfurl/constants.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/screens/link_screen.dart';
import 'package:dwarfurl/utils/alert_utils.dart';
import 'package:provider/provider.dart';
import 'package:regexpattern/regexpattern.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _firebaseProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 150.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    kLogo,
                    width: 125.0,
                    height: 125.0,
                  ),
                  Text(
                    "dwarfUrl",
                    style: GoogleFonts.balooBhai2(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Consumer<FirebaseProvider>(
              builder: (context, value, child) => Text(
                value.generating ? "Generating" : "Create a dwarf link",
                style: GoogleFonts.roboto(
                  fontSize: 30.0,
                  shadows: [
                    const Shadow(offset: Offset(0.1, 0.1), blurRadius: 0.7),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Consumer<FirebaseProvider>(
              builder: (context, value, child) {
                if (value.generating) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width > 700
                            ? MediaQuery.of(context).size.width * 0.50
                            : MediaQuery.of(context).size.width * 0.75,
                        child: Form(
                          key: _globalKey,
                          child: TextFormField(
                            controller: _controller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (str) {
                              if (str == null || str.isEmpty) {
                                return "No link found";
                              }
                              if (str.isUrl() == false) {
                                return "Not a valid url";
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              hintText: "Paste link here",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState?.validate() == true) {
                          value.generate(_controller.text).then((url) {
                            if (url != null) {
                              _controller.clear();
                              Navigator.pushNamed(
                                context,
                                LinkScreen.route
                                    .replaceAll(":id", url.split("/").last),
                              );
                            } else {
                              AlertUtils.showSnackBar(
                                context,
                                "Unable to create dwarf link. Try again",
                              );
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(20.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Generate",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
