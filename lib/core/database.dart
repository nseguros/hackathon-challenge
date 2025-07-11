import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  final String _userTable = "users";

  //String urlDatabase;

  Database? db;

  // AppDatabase({required this.urlDatabase}) {
  //  // open(urlDatabase);
  // }

  Future<Database?> open(String path) async {
    var databaseFactory = databaseFactoryFfi;
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
              version: 1,
              onCreate: (Database db, int version) async {
                await createTables(db, path);
              }));
    } else {
      var databaseFactory = databaseFactoryFfi;
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await createTables(db, path);
      });
    }

    return db;
  }

  Future<void> createTables(Database db, String path) async {
    await db.execute('''
              create  table $_userTable( 
              id integer primary key autoincrement, 
              uuid TEXT,
              username TEXT,
              name TEXT,
              surname TEXT,
              password TEXT,
              created_at TEXT,
              updated_at TEXT
              )
        ''');
  }

  Future close() async => db!.close();
}
