import 'dart:async';
import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class FirebaseProvider extends ChangeNotifier {
  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );
  bool _generating = false;
  bool get generating => _generating;

  bool _checking = false;
  bool get checking => _checking;

  String? _generatedUrl;
  String? get generatedUrl => _generatedUrl;

  bool _fetching = false;
  bool get fetching => _fetching;

  String? _originalUrl;
  String? get originalUrl => _originalUrl;

  Future<String?> generate(
    String url, {
    bool isCustomLabel = false,
    String? customLabel,
  }) async {
    _generating = true;
    notifyListeners();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: dotenv.get('URI_PREFIX_URL'),
      link: Uri.parse(url),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'dwarfUrl',
        description: 'This link is generated using dwarfUrl',
      ),
    );

    try {
      final link = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      logger.d(link.shortUrl);
      return link.shortUrl.toString();
    } catch (e) {
      logger.e(e);
      _generating = false;
      notifyListeners();
    }
    return null;
  }
}

  // Future<String?> generate(
  //   String url, {
  //   bool isCustomLabel = false,
  //   String? customLabel,
  // }) async {
  //   _generating = true;
  //   notifyListeners();
  //   DocumentSnapshot<Map<String, dynamic>>? value;
  //   try {
  //     value = await FirebaseFirestore.instance
  //         .collection("links")
  //         .doc("vnXSzHMaZzy6oPM44Soe")
  //         .get();
  //   } catch (e) {
  //     log(e.toString());
  //     _generating = false;
  //     notifyListeners();
  //     return null;
  //   }

  //   if (value.data() != null) {
  //     final data = value.data();
  //     String? key;
  //     try {
  //       key = data?.entries.firstWhere((e) => e.value == url).key;
  //     } catch (e) {
  //       log(e.toString());
  //     }
  //     if (key != null) {
  //       log(key.toString());
  //       _generating = false;
  //       _generatedUrl = kWebUrl + key;
  //       notifyListeners();
  //       return _generatedUrl;
  //     }

  //     String _generatedString = RandomString.generate(6);

  //     while (data?.keys.contains(_generatedString) == true) {
  //       _generatedString = RandomString.generate(6);
  //     }

  //     await FirebaseFirestore.instance
  //         .collection("links")
  //         .doc("vnXSzHMaZzy6oPM44Soe")
  //         .update({_generatedString: url}).catchError((err) {
  //       log(err.toString());
  //       _generating = false;
  //       notifyListeners();
  //       return null;
  //     });
  //     _generating = false;
  //     _generatedUrl = kWebUrl + _generatedString;
  //     notifyListeners();
  //     return _generatedUrl;
  //   }
  //   _generating = false;
  //   notifyListeners();
  //   return null;
  // }

  // Future<String?> getOriginalUrl(String id) async {
  //   _fetching = true;
  //   // notifyListeners();

  //   DocumentSnapshot<Map<String, dynamic>>? value;
  //   try {
  //     value = await FirebaseFirestore.instance.collection("links").doc("vnXSzHMaZzy6oPM44Soe").get();
  //   } catch (e) {
  //     log(e.toString());
  //     _fetching = false;
  //     notifyListeners();
  //     return null;
  //   }

  //   if (value.data() != null) {
  //     final data = value.data();
  //     String? originalUrl;
  //     try {
  //       originalUrl = data?.entries.firstWhere((e) => e.key == id).value;
  //     } catch (e) {
  //       log(e.toString());
  //     }
  //     if (originalUrl != null) {
  //       _fetching = false;
  //       _originalUrl = originalUrl;
  //       notifyListeners();
  //       return originalUrl;
  //     }
  //   }
  //   _fetching = false;
  //   notifyListeners();
  //   return null;
  // }

  // ///Returns true if label available
  // Future<bool?> checkIsCustomLabelAvailable(String label) async {
  //   _checking = true;
  //   notifyListeners();
  //   DocumentSnapshot<Map<String, dynamic>>? value;
  //   try {
  //     value = await FirebaseFirestore.instance.collection("links").doc("vnXSzHMaZzy6oPM44Soe").get();
  //   } catch (e) {
  //     log(e.toString());
  //     _checking = false;
  //     notifyListeners();
  //     return null;
  //   }

  //   if (value.data() != null) {
  //     final data = value.data();
  //     _checking = false;
  //     notifyListeners();
  //     return data?.keys.contains(label);
  //   }
  //   _checking = false;
  //   notifyListeners();
  //   return null;
  // }

