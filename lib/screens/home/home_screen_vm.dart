import 'package:dwarfurl/data/repositories/app_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomScreenVm extends ChangeNotifier {
  final AppRepo _appRepo;

  HomScreenVm(this._appRepo);
}
