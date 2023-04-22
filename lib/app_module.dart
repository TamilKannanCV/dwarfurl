import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @injectable
  FirebaseDynamicLinks get dynamicLinks => FirebaseDynamicLinks.instance;
}
