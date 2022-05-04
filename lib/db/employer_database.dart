import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee_model.dart';

class EmployerDatabase {
  // create instence of employee database class
  static final EmployerDatabase instance = EmployerDatabase._init();

  // create database instence
  static Database? _database;

  // construnctor
  EmployerDatabase._init();

  // Open the database connection
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('employee.db');
    return _database!;
  }

  // crete Database if database is not exist
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  // This method will run when creating the database
  Future _createTables(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableEmployers (
      $columnID $idType,
      $columnEmpId $intType,
      $columnEmpName $textType,
      $columnEmpEmail $textType,
      $columnEmpMobile $textType,
      $columnEmpType $textType,
      $columnEmpDob $textType
      )
    ''');
  }

  // add new employer
  Future<int> addEmployer(Employer employer) async {
    final db = await instance.database;

    final id = await db.insert(tableEmployers, employer.toMap());

    return id;
  }

  // get employer by id
  Future<Employer> getEmployer(int id) async {
    final db = await instance.database;

    var result =
        await db.query(tableEmployers, where: '$columnID = ?', whereArgs: [id]);

    return result.isNotEmpty
        ? Employer.fromMap(result.first)
        : throw Exception('ID $id not found');
  }

  // get all employers
  Future getAllEmployers() async {
    final db = await instance.database;

    var result = await db.query(tableEmployers);

    List employersList = result.isNotEmpty
        ? result.map((e) => Employer.fromMap(e)).toList()
        : [];

    return employersList;
  }

  // update an employer
  Future updateEmployer(Employer employer) async {
    final db = await instance.database;

    var result = await db.update(tableEmployers, employer.toMap(),
        where: '$columnID = ?', whereArgs: [employer.id]);

    return result;
  }

  // delete an employer
  Future deleteEmployer(int id) async {
    final db = await instance.database;

    var result = await db
        .delete(tableEmployers, where: '$columnID = ?', whereArgs: [id]);

    return result;
  }

  // close database connection
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
