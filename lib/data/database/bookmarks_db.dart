import 'dart:async';

import 'package:audiobookbay/data/models/category_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bookmark_model.dart';

class BookmarkDatabase {
  static final BookmarkDatabase instance = BookmarkDatabase._init();
  static Database? _database;

  BookmarkDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE $tableBookmarks(
  ${BookmarkFields.id} $idType,
  ${BookmarkFields.href} $textType,
  ${BookmarkFields.title} $textType,
  ${BookmarkFields.img} $textType
)
''');

    await db.execute('''
CREATE TABLE $tableCategory(
  ${CategoryFields.sno} $idType,
  ${CategoryFields.id} INT,
  ${CategoryFields.category} $textType
)
''');
  }

  Future<Bookmark> create(Bookmark bookmark, List<String> categoryList) async {
    final db = await instance.database;
    final id = await db.insert(tableBookmarks, bookmark.toJson());
    for (int i = 0; i < categoryList.length; i++) {
      final Category category = Category(id: id, category: categoryList[i]);
      await db.insert(tableCategory, category.toJson());
    }
    return bookmark.copy(id: id);
  }

  Future<bool> checkIfPresent(String url) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBookmarks,
      columns: BookmarkFields.values,
      where: '${BookmarkFields.href} = ?',
      whereArgs: [url],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Bookmark>> readAllBookmarks() async {
    final db = await instance.database;

    final orderBy = '${BookmarkFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableBookmarks, orderBy: orderBy);
    List<Bookmark> bookmarkList =
        result.map((json) => Bookmark.fromJson(json)).toList();
    List<String> categoryList = [];
    for (int i = 0; i < bookmarkList.length; i++) {
      final maps = await db.query(
        tableCategory,
        columns: CategoryFields.values,
        where: '${CategoryFields.id} = ?',
        whereArgs: [bookmarkList[i].id],
      );
      maps.forEach((row) => print(row['category']));
    }
    return bookmarkList;
  }

  Future update(Bookmark bookmark) async {
    final db = await instance.database;

    db.update(
      tableBookmarks,
      bookmark.toJson(),
      where: '${BookmarkFields.id} = ?',
      whereArgs: [bookmark.id],
    );
  }

  Future delete(String url) async {
    final db = await instance.database;

    await db.delete(
      tableBookmarks,
      where: '${BookmarkFields.href} = ?',
      whereArgs: [url],
    );
  }

  // TODO SEARCH LIST IMPLEMENTATION
  Future<List<Bookmark>> searchName(String text) async {
    final db = await instance.database;
    List<Map> maps = await db
        .rawQuery("SELECT * FROM $tableBookmarks WHERE title LIKE '%$text%'");
    print(maps);
    return List.generate(maps.length, (i) {
      return Bookmark(
        id: maps[i]['_id'],
        title: maps[i]['title'],
        img: maps[i]['img'],
        href: maps[i]['href'],
      );
    });
  }

  Future searchCategory(String url) async {
    final db = await instance.database;

    await db.delete(
      tableBookmarks,
      where: '${BookmarkFields.href} = ?',
      whereArgs: [url],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;

    db.close();
  }
}
