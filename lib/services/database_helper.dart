import 'package:my_notes/model/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  //This code uses a singleton pattern to ensure only one instance of DatabaseHelper is created.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  //The question mark (?) after Database makes _database a nullable type.
  // This means that _database can either store a Database instance or be null.
  //The code checks if _database is null (meaning it hasn't been initialized yet)
  // and initializes it if necessary.

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  //The code checks if the database is already created. If not, it initializes it
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //This method initializes the database by
  // setting its file path and calling openDatabase to create/open the database.
  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(), 'my_notes.db'); //join combines the database path with the database name ('my_notes.db') to create a full path.
    return await openDatabase(
        path,
      version: 1,
      onCreate: _onCreate,
    );
  }


  //This function is called the first time the database is created.
  // It defines a "notes" table to store note entries.
  Future<void> _onCreate(Database db,int version) async{ //void means the function doesn’t return any value; instead, it just performs a task.
    await db.execute('''
        CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color TEXT,
        dateTime TEXT
        )
    ''');
  }//The function will execute some code asynchronously and doesn’t need to return a result.


  Future<int> insertNote(Note note) async { //The int returned represents the ID of the newly inserted row in the database.
    final db = await database;
    return await db.insert('notes', note.toMap());
  }


  Future<List<Note>> getNotes() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes',
    orderBy: 'dateTime DESC');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }


  Future<int> updateNote(Note note) async{
    final db = await database;
    return await db.update(
        'notes',
        note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
    );
  }


  Future<int> deleteNote(int id) async{
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}