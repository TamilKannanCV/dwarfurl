import 'package:dwarfurl/screens/link_screen.dart';
import 'package:dwarfurl/screens/page_not_found_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dwarfurl/firebase_options.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => FirebaseProvider(),
      child: ResponsiveApp(
        builder: (context) {
          return MaterialApp.router(
            onGenerateTitle: (context) => "dwarfUrl",
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
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
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
                GoRoute(
                  path: '/generated',
                  builder: (context, state) => LinkScreen(
                    url: state.queryParams['url'],
                  ),
                ),
              ],
              errorBuilder: (context, state) => const PageNotFoundScreen(),
            ),
          );
        },
      ),
    ),
  );
}
