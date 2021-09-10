import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:dartz/dartz.dart';
import 'package:shortener_02/modules/domain/infra/urls_insert_repository.dart';
import 'package:shortener_02/modules/infra/datasources/url_by_short.dart';

class UrlsInsertRepositoryImpl implements UrlsInsertRepository {
  UrlByShort data;
  UrlsInsertRepositoryImpl(this.data);


  @override
  Future<Either<Failure, int>> insertUrl(String urlText) async {
    try {
      final result = await data.getShortUrl(urlText);
      return Right(result);
    } on DatasourceError catch (e) {
      print(e);
      return Left(e);
    } catch (e) {
      print(e);
      return Left(DatasourceError());
    }
  }
}