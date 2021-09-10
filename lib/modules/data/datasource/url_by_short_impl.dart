import 'dart:convert';

import 'package:http/http.dart';
import 'package:shortener_02/modules/data/datasource/datasource_helper.dart';
import 'package:shortener_02/modules/domain/error/error.dart';
import 'package:shortener_02/modules/infra/datasources/url_by_short.dart';
import 'package:shortener_02/modules/infra/models/urls_model.dart';

class UrlByShortImpl implements UrlByShort {
  var db = DatasourceHelper.instance;
  Client client;
  UrlByShortImpl(this.client, this.db);

  @override
  Future<int> getShortUrl(String urlText) async {

    
    final response = await this.client.get(Uri.parse('https://is.gd/create.php?format=json&url=$urlText'));
    
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final urlsObj = UrlsModel(
        id: 1,
        long: urlText,
        short: json['shorturl'],
        status: false,
        createdAt: DateTime.now(),
      );
      print(json['shorturl']);
      final dbInsert = await db.insertUrls(urlsObj);
      print(dbInsert);
      return dbInsert;
    } else {
      throw DatasourceError();
    }
  }
}