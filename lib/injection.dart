import 'package:dwarfurl/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.I;

@InjectableInit()
Future<void> configureDependencies() async => locator.init();
