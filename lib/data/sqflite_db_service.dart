import 'dart:io';
import 'package:aktuel/Model/Alisveris.dart';
import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  static DatabaseClient _databaseHelper;
  static Database _database;

  factory DatabaseClient(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseClient._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseClient._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "atuel.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "atuel.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> favorileriAl() async {
    var db = await _getDatabase();
    var sonuc = await db.query("favoriler");
    return sonuc;
  }

  Future<List<favoriler>> favoriListesiGetir() async {
    var urunlerMapListesi = await favorileriAl();
    List<favoriler> urunListesi = List();
    for (Map map in urunlerMapListesi) {
      urunListesi.add(favoriler.fromMapDB(map));
    }
    return urunListesi;
  }

  Future<int> favoriEkle(favoriler liste) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('favoriler',liste.toMap());
    return sonuc;
  }

  Future<int> favoriSil(String item) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(
        "favoriler", where: 'marka = ?', whereArgs: [item]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> alisverisListesiAl() async {
    var db = await _getDatabase();
    var sonuc = await db.query("Alisverislistem");
    return sonuc;
  }

  Future<List<alisveris>> alisverisListesi() async {
    var urunlerMapListesi = await alisverisListesiAl();
    List<alisveris> urunListesi = List();
    for (Map map in urunlerMapListesi) {
      urunListesi.add(alisveris.fromMap(map));
    }
    return urunListesi;
  }

  Future<int> alisverisListesiEkle(alisveris liste) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("Alisverislistem", liste.toMap());
    return sonuc;
  }

  Future<int> alisverisListesiGuncelle(alisveris item) async {
    var db = await _getDatabase();
    var sonuc = await db.update(
        "Alisverislistem", item.toMap(), where: 'itemID = ?',
        whereArgs: [item.id]);
    return sonuc;
  }

  Future<int> alisverisListesiSil(String item) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(
        "Alisverislistem", where: 'itemID = ?', whereArgs: [item]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> sayfaisaretleriniAl() async {
    var db = await _getDatabase();
    var sonuc = await db.query("Sayfaisaretleri");
    return sonuc;
  }

  Future<List<Urunler>> sayfaisaretleriniGetir() async {
    var urunlerMapListesi = await sayfaisaretleriniAl();
    List<Urunler> urunListesi2 = List();
    for (Map map in urunlerMapListesi) {
      urunListesi2.add(Urunler.fromMapFavor(map));
    }
    return urunListesi2;
  }

  Future<int> sayfaisaretiEkle(Urunler liste) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("Sayfaisaretleri", liste.toMap());
    return sonuc;
  }

  Future<int> sayfaisaretiSil(String item) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(
        "Sayfaisaretleri", where: 'resim = ?', whereArgs: [item]);
    return sonuc;
  }


}