import 'dart:convert';

import 'package:shortener_02/modules/domain/entities/urls.dart';

class UrlsModel extends Urls {
  final int? id;
  final String long;
  final String short;
  final bool status;
  final DateTime createdAt;
  
  UrlsModel({
    this.id,
    required this.long,
    required this.short,
    required this.status,
    required this.createdAt,
  }) : super(
    long: '',
    short: '',
    status: true,
    createdAt: DateTime.now()
  );

  UrlsModel.withId({
    required this.id,
    required this.long,
    required this.short,
    required this.status,
    required this.createdAt,
  }) : super(
    long: '',
    short: '',
    status: true,
    createdAt: DateTime.now()
  );
  
  Map<String, dynamic> toMap() {
    return {
      if(id == null) 'id': id,
      'long': long,
      'short': short,
      'status': status ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UrlsModel.fromMap(Map<String, dynamic> map) {
    return UrlsModel(
      id: map['id'],
      long: map['long'],
      short: map['short'],
      status: map['status'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UrlsModel.fromJson(String source) => UrlsModel.fromMap(json.decode(source));

}
