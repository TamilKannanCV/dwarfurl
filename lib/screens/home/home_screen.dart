import 'dart:async';

import 'package:dwarfurl/gen/assets.gen.dart';
import 'package:dwarfurl/gen/fonts.gen.dart';
import 'package:dwarfurl/screens/home/home_screen_vm.dart';
import 'package:dwarfurl/utils/alert_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Helps to implement 2 back to exit
  int backPressCount = 0;

  late HomScreenVm homScreenVm;

  Timer? backBounceTimer;

  @override
  void initState() {
    super.initState();
    homScreenVm = Provider.of<HomScreenVm>(context, listen: false);
  }

  @override
  void dispose() {
    backBounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (homScreenVm.generatedShortUrl != null) {
          homScreenVm.createNew();
          return false;
        }
        if (backPressCount == 0) {
          backPressCount++;
          Timer.periodic(const Duration(seconds: 2), (_) {
            backPressCount = 0;
            _.cancel();
          });
          AlertUtils.showSnackBar(context, "Press back again to exit");
          return false;
        }
        if (backPressCount == 1) {
          backBounceTimer?.cancel();
          return true;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Consumer<HomScreenVm>(builder: (context, model, child) {
                if (model.generating) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: const Text(
                                  "Generating short link, Please wait...",
                                  style: TextStyle(
                                    fontFamily: FontFamily.productSans,
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 10.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.images.logoSvg.svg(
                              height: 80.0,
                              width: 80.0,
                            ),
                            Text(
                              "dwarfUrl",
                              style:
                                  GoogleFonts.ubuntuCondensed(fontSize: 23.0),
                            ),
                            Text("v${model.packageInfo.version}")
                          ],
                        ),
                      )
                    ],
                  );
                }
                if (model.generatedShortUrl != null) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  "${model.generatedShortUrl}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: FontFamily.productSans,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: [
                                  FilledButton.icon(
                                    onPressed: () async {
                                      await model
                                          .copyToClipboard(_controller.text);
                                      if (!mounted) return;
                                      AlertUtils.showSnackBar(
                                          context, "Copied to clipboard!");
                                    },
                                    label: const Text("Copy to clipboard"),
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 20.0,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: model.createNew,
                                    label: const Text("Create new"),
                                    icon: const Icon(
                                      Icons.new_label_outlined,
                                      size: 20.0,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        left: 0.0,
                        right: 0.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.images.logoSvg.svg(
                              height: 80.0,
                              width: 80.0,
                            ),
                            Text(
                              "dwarfUrl",
                              style:
                                  GoogleFonts.ubuntuCondensed(fontSize: 23.0),
                            ),
                            Text("v${model.packageInfo.version}")
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.logoSvg.svg(
                        height: 150.0,
                        width: 150.0,
                      ),
                      Text(
                        "dwarfUrl",
                        style: GoogleFonts.ubuntuCondensed(fontSize: 30.0),
                      ),
                      const SizedBox(height: 50.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: const Text(
                          "Paste any long url you want to convert into dwarfUrl",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "paste link here",
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              if (!isFQDN(value) && !isURL(value)) {
                                return "Invalid url";
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      FilledButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == false) {
                            return;
                          }
                          model.generateShortUrl(_controller.text.trim());
                        },
                        icon: const Icon(Icons.link),
                        label: const Text("Create short link"),
                        style: FilledButton.styleFrom(
                          fixedSize: const Size(200, 50),
                          textStyle: const TextStyle(
                            fontSize: 17.0,
                            fontFamily: FontFamily.productSans,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
