import 'package:clipboard/clipboard.dart';
import 'package:dwarfurl/screens/home_screen.dart';
import 'package:dwarfurl/screens/page_not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:dwarfurl/constants.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/utils/alert_utils.dart';
import 'package:dwarfurl/widgets/circle_icon_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import 'dart:html' as html;

class LinkScreen extends StatefulWidget {
  static String route = "/generated/:id";
  static const String routeWithId = "/:id";
  const LinkScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  _LinkScreenState createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  FirebaseProvider? _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
    _firebaseProvider?.getOriginalUrl(widget.id ?? '').then((value) async {
      if (ModalRoute.of(context)?.settings.name?.contains("/generated") ==
          false) {
        if (value != null) await launchUrl(value);
      }
    });
  }

  @override
  void dispose() {
    _firebaseProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<FirebaseProvider>(
          builder: (context, value, child) {
            if (value.fetching) return const CircularProgressIndicator();

            if (value.originalUrl == null) {
              return const PageNotFoundScreen();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "$kWebUrl${widget.id}",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85,
                            ),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Original url:",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Tooltip(
                                        message: "Click to open website",
                                        child: GestureDetector(
                                          child: Text(
                                            " ${value.originalUrl}",
                                            style:
                                                const TextStyle(fontSize: 17.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          onTap: () async {
                                            await launchUrl(
                                              "${value.originalUrl}",
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (ModalRoute.of(context)
                                      ?.settings
                                      .name
                                      ?.contains("/generated") ==
                                  true)
                                CircleIconButton(
                                  tooltip: "Copy to clipboard",
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            kWebUrl + widget.id.toString())
                                        .then((value) {
                                      AlertUtils.showSnackBar(
                                        context,
                                        "Copied to clipboard!",
                                      );
                                    });
                                  },
                                ),
                              const SizedBox(width: 30.0),
                              CircleIconButton(
                                tooltip: "Open website",
                                icon: const Icon(Icons.launch),
                                onPressed: () async {
                                  await launchUrl(
                                      "${_firebaseProvider?.originalUrl}");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
                        style: GoogleFonts.ubuntuCondensed(),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> launchUrl(String? url) async {
    String originalUrl = "$url";
    if (originalUrl.startsWith("http") == false) {
      originalUrl = "http://$originalUrl";
    }

    // html.window.open(originalUrl, "originalUrl");

    if (await canLaunch(originalUrl)) await launch(originalUrl);
  }
}
