import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqliteconcept/models/contact.dart';

class DatabaseHelper {
  static const _databasename = 'contactData.db';
  static const _databaseversion = 1;
  //singleton class

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } //return database if database is already initialize
    _database = await _initDatabase();
    return _database;
  }

//initialization the database
  _initDatabase() async {
    Directory dataDirectory =
        await getApplicationDocumentsDirectory(); //getting the application directory
    String dbpath = join(dataDirectory.path, _databasename); //getting the path
    return await openDatabase(dbpath,
        version: _databaseversion, onCreate: _onCreateDB); //opening the data
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Contact.tblContact} ( 
    ${Contact.colID} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Contact.colName} TEXT NOT NULL,
    ${Contact.colMobile} TEXT NOT NULL, 
    )
      
    ''');
  }

// inserting data into the database
  Future<int> insertContact(Contact contact) async {
    Database? db = await database;
    return await db!.insert(Contact.tblContact, contact.toMap());
  }

//updating database
  Future<int> updatetContact(Contact contact) async {
    Database? db = await database;
    return await db!.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colID}=?', whereArgs: [contact.id]);
  }

//deleting from data base
  Future<int> deleteContact(int id) async {
    Database? db = await database;
    return await db!.delete(Contact.tblContact,
        where: '${Contact.colID}=?', whereArgs: [id]);
  }

//fetching data into the database
  //Future<List<Contact>> fetchContact() async {
  //Database? db = await database;
  //List<Map> contacts = await db!.query(Contact.tblContact);
  //if (contacts.isEmpty) {
  //return [];
  //} else {
  //return contacts.map((e) => Contact.fromMap(e)).toList();
}
//}
//}
