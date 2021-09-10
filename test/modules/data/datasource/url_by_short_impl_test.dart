
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shortener_02/modules/data/datasource/datasource_helper.dart';
import 'package:shortener_02/modules/data/datasource/url_by_short_impl.dart';
import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:shortener_02/modules/infra/models/urls_model.dart';
import 'package:shortener_02/modules/utils/isgd_response.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ClientMock extends Mock implements Client {}
class DatasourceHelperMock extends Mock implements DatasourceHelper {}

main() {
  final client = ClientMock();
  final db = DatasourceHelperMock();
  final datasource = UrlByShortImpl(client, db);
  String urlText = 'https://www.youtube.com/watch?v=AeIOvYRPvLM';

  sqfliteFfiInit();

  final urls = UrlsModel(
        long: urlText,
        short: 'json',
        status: false,
        createdAt: DateTime.now(),
      );
  test('Deve retornar um inteiro após a inserção de um urlModel no db', () async {
    when(() => client.get(Uri.parse('https://is.gd/create.php?format=json&url=$urlText'))).thenAnswer((_) async => Response(isgdResponse, 200));
    // when(() => db.insertUrls(urls)).thenAnswer((_) async => 1);

    final future = await datasource.getShortUrl(urlText);
    final result = await db.insertUrls(urls);

    expect(result, isA<int>());
    expect(future, completes);
  });

  test('Deve retornar um erro se o código não for 200', () async {
    when(() => client.get(Uri.parse('https://is.gd/create.php?format=json&url=$urlText'))).thenThrow(Exception());
    final result = await db.insertUrls(urls);
    expect(result, isA<DatasourceError>());
  });
}