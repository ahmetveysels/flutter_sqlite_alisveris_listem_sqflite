import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite_example_avdisx/model/alisveris_liste.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/* Code by avdisx */
class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      return DatabaseHelper._internal();
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

//bu kısım sqflite github sayfasından alındı.
  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "appDB.db");
    print(path);

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // assetsten veritabanını kopyala
      ByteData data =
          await rootBundle.load(join("assets", "alisveris_listem.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
      // Databaseyi çalıştır
    var _db = await openDatabase(path, readOnly: false);
    print(path);
    return _db;
  }

   // Tablo İşlemleri

  Future<List<Map<String, dynamic>>> malzemeleriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("alisveris_listem", orderBy: "id DESC");
    return sonuc;
  }

  Future<List<ALISVERISLISTEM>> malzemelerinListesi() async {
    var malzemelerMapListesi = await malzemeleriGetir();
    var malzemelerListesi = List<ALISVERISLISTEM>();

    for (Map map in malzemelerMapListesi) {
      var secili = ALISVERISLISTEM.fromMap(map);

      malzemelerListesi.add(secili);
    }
    return malzemelerListesi;
  }

  Future<int> malzemeEkle(ALISVERISLISTEM listem) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("alisveris_listem", listem.toMap());
    return sonuc;
  }

  Future<int> malzemeGuncelle(ALISVERISLISTEM listem) async {
    var db = await _getDatabase();
    var sonuc = await db.update("alisveris_listem", listem.toMap(),
        where: 'id = ?', whereArgs: [listem.id]);
    return sonuc;
  }

  Future<int> malzemeSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete("alisveris_listem", where: 'id = ?', whereArgs: [id]);
    return sonuc;
  }
}
