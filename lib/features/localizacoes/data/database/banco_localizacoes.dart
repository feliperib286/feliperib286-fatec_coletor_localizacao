import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoLocalizacoes {
  static final BancoLocalizacoes _instance = BancoLocalizacoes._internal();
  static Database? _database;

  BancoLocalizacoes._internal();
  factory BancoLocalizacoes() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'localizacoes.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE localizacoes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL,
              precisao REAL NOT NULL,
              instante TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      _database = null;
      rethrow;
    }
  }
}
