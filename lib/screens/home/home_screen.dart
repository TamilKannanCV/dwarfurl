import 'package:avatar_glow/avatar_glow.dart';
import 'package:dwarfurl/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwarfurl/constants.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/utils/alert_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../link_screen.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<FirebaseProvider>(
                  builder: (context, value, child) {
                    if (value.generating) {
                      return AvatarGlow(
                        glowColor: Colors.blue,
                        endRadius: 150.0,
                        child: child!,
                      );
                    }
                    return Container(margin: const EdgeInsets.all(10.0), child: child!);
                  },
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
                        style: GoogleFonts.ubuntuCondensed(fontSize: 30.0),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Consumer<FirebaseProvider>(
                  builder: (context, value, child) => Text(
                    value.generating ? "Generating" : "Create your own dwarfUrl",
                    style: GoogleFonts.roboto(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                Consumer<FirebaseProvider>(
                  builder: (context, value, child) {
                    if (value.generating) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Wrap(
                      spacing: 10.0,
                      runSpacing: 15.0,
                      alignment: WrapAlignment.center,
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width > 700 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 0.75,
                            child: Form(
                              key: _globalKey,
                              child: TextFormField(
                                controller: _controller,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (str) {
                                  if (str == null || str.trim().isEmpty) {
                                    return "No link found";
                                  }
                                  if (!(isURL(str.trim()) || isFQDN(str.trim()))) {
                                    return "Not a valid link";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Paste link here",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                    vertical: 15.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 30.0),
                        FilledButton(
                          onPressed: () async {
                            if (_globalKey.currentState?.validate() == true) {
                              value.generate(_controller.text.trim()).then((url) {
                                if (url != null) {
                                  _controller.clear();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LinkScreen(url: url),
                                    ),
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
                          child: const Text(
                            "Generate",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          )),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: IconButton(
              onPressed: () async {
                final package = await PackageInfo.fromPlatform();
                if (!mounted) return;
                showAboutDialog(
                  context: context,
                  applicationName: "dwarfUrl",
                  applicationIcon: Assets.images.logoSvg.svg(
                    height: 80.0,
                    width: 80.0,
                  ),
                  applicationLegalese: "Tamil KannanCV",
                  applicationVersion: package.version,
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          )
        ],
      ),
    );
  }
}
