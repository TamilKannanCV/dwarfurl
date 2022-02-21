import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:dwarfurl/constants.dart';
import 'package:dwarfurl/random_string.dart';

class FirebaseProvider extends ChangeNotifier {
  bool _generating = false;
  bool get generating => _generating;

  String? _generatedUrl;
  String? get generatedUrl => _generatedUrl;

  bool _fetching = false;
  bool get fetching => _fetching;

  String? _originalUrl;
  String? get originalUrl => _originalUrl;

  Future<String?> generate(String url) async {
    _generating = true;
    notifyListeners();
    DocumentSnapshot<Map<String, dynamic>>? value;
    try {
      value = await FirebaseFirestore.instance
          .collection("links")
          .doc("vnXSzHMaZzy6oPM44Soe")
          .get();
    } catch (e) {
      log(e.toString());
      _generating = false;
      notifyListeners();
      return null;
    }

    if (value.data() != null) {
      final data = value.data();
      String? key;
      try {
        key = data?.entries.firstWhere((e) => e.value == url).key;
      } catch (e) {
        log(e.toString());
      }
      if (key != null) {
        log(key.toString());
        _generating = false;
        _generatedUrl = kWebUrl + key;
        notifyListeners();
        return _generatedUrl;
      }

      String _generatedString = RandomString.generate(6);

      while (data?.keys.contains(_generatedString) == true) {
        _generatedString = RandomString.generate(6);
      }

      await FirebaseFirestore.instance
          .collection("links")
          .doc("vnXSzHMaZzy6oPM44Soe")
          .update({_generatedString: url}).catchError((err) {
        log(err.toString());
        _generating = false;
        notifyListeners();
        return null;
      });
      _generating = false;
      _generatedUrl = kWebUrl + _generatedString;
      notifyListeners();
      return _generatedUrl;
    }
    _generating = false;
    notifyListeners();
    return null;
  }

  Future<String?> getOriginalUrl(String id) async {
    _fetching = true;
    // notifyListeners();

    DocumentSnapshot<Map<String, dynamic>>? value;
    try {
      value = await FirebaseFirestore.instance
          .collection("links")
          .doc("vnXSzHMaZzy6oPM44Soe")
          .get();
    } catch (e) {
      log(e.toString());
      _fetching = false;
      notifyListeners();
      return null;
    }

    if (value.data() != null) {
      final data = value.data();
      String? originalUrl;
      try {
        originalUrl = data?.entries.firstWhere((e) => e.key == id).value;
      } catch (e) {
        log(e.toString());
      }
      if (originalUrl != null) {
        _fetching = false;
        _originalUrl = originalUrl;
        notifyListeners();
        return originalUrl;
      }
    }
    _fetching = false;
    notifyListeners();
    return null;
  }
}
