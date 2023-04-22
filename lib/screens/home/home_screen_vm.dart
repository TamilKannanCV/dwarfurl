import 'package:any_link_preview/any_link_preview.dart';
import 'package:dwarfurl/data/repositories/app_repo.dart';
import 'package:dwarfurl/data/repositories/app_repo_impl.dart';
import 'package:flutter/material.dart' hide MetaData;
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@injectable
class HomScreenVm extends ChangeNotifier {
  final AppRepo _appRepo;
  final PackageInfo packageInfo;

  HomScreenVm(this._appRepo, this.packageInfo);

  bool _generating = false;
  bool get generating => _generating;
  set generating(bool value) {
    _generating = value;
    notifyListeners();
  }

  String? _generatedShortUrl;
  String? get generatedShortUrl => _generatedShortUrl;
  set generatedShortUrl(String? value) {
    _generatedShortUrl = value;
    notifyListeners();
  }

  Metadata? _metaData;
  Metadata? get metaData => _metaData;
  set metaData(Metadata? value) {
    _metaData = value;
    notifyListeners();
  }

  Future<void> generateLinkPreview(String url) async {
    try {
      metaData = await AnyLinkPreview.getMetadata(link: url);
    } finally {}
  }

  Future<void> generateShortUrl(String url) async {
    generating = true;
    generatedShortUrl = null;

    final response = await _appRepo.generateShortUrl(url);
    generating = false;
    response.fold(
      (e) {},
      (shortUrl) {
        generatedShortUrl = shortUrl;
      },
    );
  }

  Future<void> copyToClipboard(String text) =>
      Clipboard.setData(ClipboardData(text: text));

  void createNew() {
    generatedShortUrl = null;
    metaData = null;
  }
}
