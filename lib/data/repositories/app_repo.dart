import 'package:dartz/dartz.dart';

abstract class AppRepo {
  Future<Either<dynamic, String>> generateShortUrl(String url);
}
