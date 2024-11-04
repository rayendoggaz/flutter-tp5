import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/scol_list.dart';
import '../models/list_etudiants.dart';

class dbuse {
  final int version = 1;
  Database? _db;

  static final dbuse _dbHelper = dbuse._internal();
  dbuse._internal();

  factory dbuse() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    // Open the database only if it's not already opened
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), 'scol.db'),
      onCreate: (database, version) {
        // Create tables
        database.execute(
            'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
        database.execute(
            'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, FOREIGN KEY(codClass) REFERENCES classes(codClass))');
      },
      version: version,
    );
    return _db!;
  }

  Future<void> closeDb() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  // Insert methods
  Future<int> insertClass(ScolList list) async {
    final db = await openDb();
    return await db.insert('classes', list.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertEtudiant(ListEtudiants etudiant) async {
    final db = await openDb(); // Ensure the database is open
    return await db.insert(
      'etudiants',
      etudiant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if there's a conflict
    );
  }

  // Retrieve classes
  Future<List<ScolList>> getClasses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('classes');
    return List.generate(maps.length, (i) {
      return ScolList(
        maps[i]['codClass'],
        maps[i]['nomClass'],
        maps[i]['nbreEtud'],
      );
    });
  }

  // Retrieve students
  Future<List<ListEtudiants>> getEtudiants(int codClass) async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('etudiants', where: 'codClass = ?', whereArgs: [codClass]);
    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['datNais'],
      );
    });
  }

  // Method to update an existing student in the "etudiants" table
  Future<int> updateEtudiant(ListEtudiants etudiant) async {
    final db = await openDb(); // Ensure the database is open
    return await db.update(
      'etudiants',
      etudiant.toMap(),
      where: 'id = ?', // Update the record where the id matches
      whereArgs: [etudiant.id],
    );
  }
}
