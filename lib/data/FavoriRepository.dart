import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

class FAvoriRepository {
  DatabaseClient FavoriurunClient = getIt<DatabaseClient>();

  Future<List<Urunler>> getUrun() async {
    return await FavoriurunClient.sayfaisaretleriniGetir();
  }
}