import 'dart:developer';

import 'package:dwarfurl/screens/home_screen.dart';
import 'package:dwarfurl/screens/link_screen.dart';

class AppRoutePath {
  String? id;
  bool isUnknown = false;
  late String location;

  AppRoutePath(this.id, this.isUnknown, this.location);

  factory AppRoutePath.home() {
    return AppRoutePath(null, false, HomeScreen.route);
  }

  factory AppRoutePath.link(String? id) {
    return AppRoutePath(
      id,
      false,
      LinkScreen.routeWithId.replaceAll(':id', id ?? ''),
    );
  }
  factory AppRoutePath.generatedLink(String? id) {
    return AppRoutePath(
      id,
      false,
      LinkScreen.route.replaceAll(":id", id ?? ''),
    );
  }

  factory AppRoutePath.unknown() {
    return AppRoutePath(null, true, '/404');
  }

  factory AppRoutePath.fromUrl(String url) {
    final uri = Uri.parse(url);

    // Handle '/'
    if (uri.pathSegments.isEmpty) return AppRoutePath.home();

    // Handle 'generated'
    if (uri.pathSegments.first == "generated") {
      if (uri.pathSegments.length == 1) return AppRoutePath.unknown();
      final id = uri.pathSegments.elementAt(1);
      log(id.toString());
      return AppRoutePath.generatedLink(id);
    }

    // Handle 'id'
    if (uri.pathSegments.first.length == 6) {
      log(uri.pathSegments.first.toString() + " id");
      return AppRoutePath.link(uri.pathSegments.first);
    }

    return AppRoutePath.unknown();
  }
}
