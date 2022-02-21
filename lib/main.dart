import 'dart:developer';
import 'dart:js';

import 'package:dwarfurl/routes/app_route_path.dart';
import 'package:dwarfurl/screens/link_screen.dart';
import 'package:dwarfurl/screens/page_not_found_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dwarfurl/firebase_options.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => FirebaseProvider(),
      child: MaterialApp(
        onGenerateTitle: (context) => "DwarfUrl",
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    ),
  );
}

Route<dynamic>? _generateRoute(RouteSettings settings) {
  log(settings.name.toString());
  final appRoutePath = AppRoutePath.fromUrl(settings.name ?? '/');
  if (appRoutePath.location == '/') {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
  if (appRoutePath.id != null) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => LinkScreen(id: appRoutePath.id),
    );
  }

  return MaterialPageRoute(builder: (context) => const PageNotFoundScreen());
}
