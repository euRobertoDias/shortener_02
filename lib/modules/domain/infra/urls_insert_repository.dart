import '../error/error.dart';
import 'package:dartz/dartz.dart';

abstract class UrlsInsertRepository {
  Future<Either<Failure, int>> insertUrl(String urlText);
}