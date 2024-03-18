import 'dart:async';
import 'dart:core';

import 'package:flutter_application_1/model/snippet_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class SnippetDataBase{
  static final SnippetDataBase instance = SnippetDataBase._init();
  static Database? _database;
  SnippetDataBase._init();

  Future<Database> get database async{
    if(_database != null)  return _database!;
    _database  = await _initDB('snippet_db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath  = await getDatabasesPath();
    final path =  join(dbPath,filePath);
    return await openDatabase(path,version: 1,onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $snippetNote (
    ${SnippetFields.id} $idType,
    ${SnippetFields.createdTime} $textType,
    ${SnippetFields.title} $textType,
    ${SnippetFields.codeSnippet} $textType
    )
    ''');

  }

  Future<List<Snippet>> readAllNote() async{
    final db  = await instance.database;
    final orderBy = '${SnippetFields.createdTime} ASC';
    final result = await db.query(snippetNote,orderBy: orderBy);
    return result.map((json) => Snippet.fromJson(json)).toList();
  }

  Future createSnippet(Snippet snippet) async{
    final db  = await instance.database;
    db.insert(snippetNote, snippet.toJson());
  }



  Future close() async{
    final db  = await instance.database;
    db.close();
  }


}