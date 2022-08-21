import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(join(dbPath, 'places.db'),
      onCreate: (db, version) => db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT, loc_lat REAL, loc_lng REAL, address TEXT)',
          ),
      version: 1);
}

Future<void> insert(String table, Map<String, dynamic> data) async {
  final db = await database();
  await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> getData(String table) async {
  final db = await database();
  return db.query(table);
}
