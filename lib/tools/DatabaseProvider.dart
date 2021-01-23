import 'dart:async';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final _databaseName = 'budgetour_table';
  static final _databaseVersion = 1;

  // Private Constructor
  DatabaseProvider._();
  // Creating singleton from ^^^ constructor
  static final DatabaseProvider instance = DatabaseProvider._();

  // Create single connection to database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  // Connect to database
  Future<Database> _initDatabase() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    Batch creationBatch = db.batch();

    /// Create main tables (finance objects)
    creationBatch.execute("CREATE TABLE ");

    await creationBatch.commit();
  }

  Future<int> insert(FinanceObject object) async {
    // Connect to database
    Database db = await database;
    int id = await db.insert(object.tableName, object.toMap(),

        /// TODO: REVISE THIS
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<FinanceObject> query(int id) async {
    Database db = await database;
    List<Map> maps = await db.query('TASKTABLE',
        columns: ['TASK_ID', 'TASK_NAME', 'TASK_TIME', 'TASK_CONTEXT'],
        where: '\$TASK_ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      //FinanceObject task = FinanceObject.fromMap(maps.first);
      //return task;
    }
    return null;
  }

  static Future<FinanceObject> read(FinanceObject task) async {
    DatabaseProvider db = DatabaseProvider.instance;
    FinanceObject loadedTask = await db.query(task.getId());
    if (loadedTask == null) {
      //print('failed to load: ${task.getTitle()}');
    } else {
      print('loaded: ${loadedTask.getTitle()} @ ${loadedTask.getTime()}');
    }
    return loadedTask;
  }

  static save(Task task) async {
    DatabaseProvider db = DatabaseProvider.instance;
    int id = await db.insert(task);
    print('save successful: $id verification: ${task.getId()}');
  }
}
