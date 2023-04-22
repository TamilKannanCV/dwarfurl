import 'package:dartz/dartz.dart';
import 'package:dwarfurl/data/repositories/app_repo.dart';
import 'package:dwarfurl/data/services/api_services.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AppRepo)
class AppRepoImpl implements AppRepo {
  final ApiServices _apiServices;

  AppRepoImpl(this._apiServices);

  @override
  Future<Either<dynamic, String>> generateShortUrl(String url) async {
    try {
      final shortUrl = await _apiServices.generateShortUrl(url);
      return Right(shortUrl);
    } catch (e) {
      return Left(e);
    }
  }
}
