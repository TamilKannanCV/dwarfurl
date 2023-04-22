import 'package:dwarfurl/injection.dart';
import 'package:dwarfurl/screens/home/home_screen_vm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dwarfurl/firebase_options.dart';
import 'package:dwarfurl/providers/firebase_provider.dart';
import 'package:dwarfurl/screens/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    setPathUrlStrategy();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<HomScreenVm>()),
      ],
      child: MaterialApp(
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
        home: const HomeScreen(),
      ),
    ),
  );
}
