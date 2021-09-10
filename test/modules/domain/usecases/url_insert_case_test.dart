import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:shortener_02/modules/domain/infra/urls_insert_repository.dart';
import 'package:shortener_02/modules/domain/usecases/url_insert_case.dart';

class UrlsInsertRepositoryMock extends Mock implements UrlsInsertRepository {}

main() {
  final repository = UrlsInsertRepositoryMock();
  final usecase = UrlInsertCaseImpl(repository);
  

  test('Deve retornar um objeto de urls', () async {
    when(() => repository.insertUrl('www.google.com')).thenAnswer((_) async => Right(1));
    final result = await usecase.call('www.google.com');
    expect(result, isA<Right>());
    expect(result.fold(id, id), isA<int>());
  });

  test('Deve retornar um erro', () async {
    when(() => repository.insertUrl('')).thenAnswer((_) async => Right(1));
    final result = await usecase.call('');
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<InvalidTextError>());
  });

}