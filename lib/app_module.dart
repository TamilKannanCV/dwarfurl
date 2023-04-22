import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class AppModule {
  @injectable
  FirebaseDynamicLinks get dynamicLinks => FirebaseDynamicLinks.instance;

  @injectable
  @preResolve
  Future<PackageInfo> get packageInfo async => PackageInfo.fromPlatform();
}
