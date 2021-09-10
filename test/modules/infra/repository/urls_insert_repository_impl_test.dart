import 'package:mocktail/mocktail.dart';
import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:shortener_02/modules/infra/datasources/url_by_short.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortener_02/modules/infra/repository/urls_insert_repository_impl.dart';
import 'package:dartz/dartz.dart';

class UrlByShortMock extends Mock implements UrlByShort {}

main() {
  final datasource = UrlByShortMock();
  final repository = UrlsInsertRepositoryImpl(datasource);

  test('Deve retornar um Either de Um objeto de Urls', () async {
    when(() => datasource.getShortUrl('www.google.com')).thenAnswer((_) async => 1);

    final result = await repository.insertUrl('www.google.com');
    expect(result.fold(id, id), isA<int>());
  });

  test('Deve retornar um erro DatasourceError', () async {
    when(() => datasource.getShortUrl('www.google.com')).thenThrow(Exception());
    final result = await repository.insertUrl('www.google.com');
    expect(result.fold(id, id), isA<DatasourceError>());
  });
}