import 'package:dartz/dartz.dart';
import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:shortener_02/modules/domain/infra/urls_insert_repository.dart';

abstract class UrlInsertCase {
  Future<Either<Failure, int>> call(String urlText);
}

class UrlInsertCaseImpl implements UrlInsertCase{
  UrlsInsertRepository repository;
  UrlInsertCaseImpl(this.repository);

  @override
  Future<Either<Failure, int>> call(String urlText) async {
    if(urlText.isEmpty) {
      return Left(InvalidTextError());
    }

    return repository.insertUrl(urlText);
  }
}