import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shortener_02/modules/infra/models/urls_model.dart';
import 'package:sqflite/sqflite.dart';

class DatasourceHelper {
  static final DatasourceHelper instance = DatasourceHelper._instance();
  static Database? _db;
  DatasourceHelper._instance();

  String urlsTable = 'urls_table';
  String colId = 'id';
  String colLongUrl = 'long';
  String colShortUrl = 'short';
  String colDate = 'date';
  String colStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }

    return _db!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'urls.db';
    final urlsDb = openDatabase(path, version: 1, onCreate: _createDb);
    return urlsDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $urlsTable('
      '$colId INTEGER PRIMARY KEY AUTOINCREMENT, $colLongUrl TEXT NOT NULL, $colShortUrl TEXT NOT NULL,'
      ' $colDate TEXT NOT NULL, $colStatus INTERGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getUrlsMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(urlsTable);
    return result;
  }

  Future<List<UrlsModel>> getUrlsList() async {
    final List<Map<String, dynamic>> urlsMapList = await getUrlsMapList();
    final List<UrlsModel> urlsList = [];

    urlsMapList.forEach((urlsMap) {
      urlsList.add(UrlsModel.fromMap(urlsMap));
    });

    // urlsList.sort((urlsA?, urlsB?) => urlsA.date?.compareTo(urlsB.date));
    return urlsList;
  }

  Future<int> insertUrls(UrlsModel urls) async {
    Database db = await this.db;
    final result = await db.insert(urlsTable, urls.toMap());
    return result;
  }

  Future<int> updateUrls(UrlsModel urls) async {
    Database db = await this.db;
    final int result = await db.update(
      urlsTable,
      urls.toMap(),
      where: '$colId = ?',
      whereArgs: [urls.id],
    );
    return result;
  }

  Future<int> deleteUrls(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      urlsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<void> close() async {
    final closed = await _db!.close();
    return closed;
  }
}