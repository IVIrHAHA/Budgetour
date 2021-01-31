import 'dart:async';
import 'package:budgetour/models/BudgetourReserve.dart' as br;
import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
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

    /// Create main tables
    // FinanceObject Table
    creationBatch.execute(
      "CREATE TABLE ${DbNames.fo_TABLE}("
      "${DbNames.fo_Category} INTEGER,"
      "${DbNames.fo_ObjectId} REAL PRIMARY KEY,"
      "${DbNames.fo_CashReserve} REAL,"
      "${DbNames.fo_Object} TEXT,"
      "${DbNames.fo_Type} TEXT"
      ")",
    );

    // Transaction Table
    creationBatch.execute("CREATE TABLE ${DbNames.trxt_TABLE}("
        "${DbNames.trxt_id} REAL,"
        "${DbNames.trxt_amount} REAL,"
        "${DbNames.trxt_description} TEXT,"
        "${DbNames.trxt_date} INTEGER,"
        "${DbNames.trxt_color} INTEGER,"
        "${br.TRXT_KEY} INTEGER PRIMARY KEY"
        ")");

    // // CashHandler Table
    // creationBatch.execute("CREATE TABLE ${DbNames.ch_TABLE}");

    await creationBatch.commit();
  }

  Future<int> insert(Object object, String tablename) async {
    // Connect to database
    Database db = await database;

    // Trying to save a FinanceObject
    if (object is FinanceObject && tablename == DbNames.fo_TABLE) {
      int id = await db.insert(DbNames.fo_TABLE, object.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    }

    // Trying to save a CashHandler
    else if (object is br.CashHandler && tablename == DbNames.ch_TABLE) {
    }

    // Trying to save a Transaction
    else if (object is br.Transaction && tablename == DbNames.trxt_TABLE) {
      Database db = await database;

      if (object is br.Transaction && tablename == DbNames.trxt_TABLE) {
        int id = await db.insert(DbNames.trxt_TABLE, object.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);

        print('transaction has been saved');
        return id;
      }
    } else {
      throw Exception('Not a valid dbase insert query');
    }
  }

  static save(FinanceObject obj) async {
    instance.insert(obj, DbNames.fo_TABLE);
    print('Success');
  }

  Future saveAll() async {
    print('saving all');
    Database db = await database;
    Batch batch = db.batch();

    CategoryListManager.instance.getAllObjects().forEach((element) {
      print('saving ${element.name}');
      db.insert(DbNames.fo_TABLE, element.toMap());
    });

    batch.commit();
  }

  Future<List<Map>> loadAll() async {
    Database db = await database;
    List<Map> mapList = await db.query(DbNames.fo_TABLE, columns: [
      DbNames.fo_Object,
      DbNames.fo_Type,
      DbNames.fo_CashReserve,
      DbNames.fo_Category,
    ]);

    if (mapList.length > 0) {
      return mapList;
    }
    return null;
  }

  Future<List<Map>> loadTransactions(double transactionLink) async {
    Database db = await database;
    List<Map> mapList = await db.query(DbNames.trxt_TABLE,
        columns: [
          DbNames.trxt_id,
          DbNames.trxt_amount,
          DbNames.trxt_description,
          DbNames.trxt_date,
          DbNames.trxt_color,
          br.TRXT_KEY,
        ],
        where: "${DbNames.trxt_id} = ?",
        whereArgs: [transactionLink]);

    if (mapList.length > 0) {
      return mapList;
    } else {
      print('nothing loaded from ${DbNames.trxt_TABLE}');
      return List();
    }
  }

  // /// TODO: When done loading verity with BudgetReserve that cash is in sync
  // Future<FinanceObject> aquery(int id) async {
  //   Database db = await database;
  //   List<Map> maps = await db.query('TASKTABLE',
  //       columns: ['TASK_ID', 'TASK_NAME', 'TASK_TIME', 'TASK_CONTEXT'],
  //       where: '\$TASK_ID = ?',
  //       whereArgs: [id]);

  //   if (maps.length > 0) {
  //     //FinanceObject task = FinanceObject.fromMap(maps.first);
  //     //return task;
  //   }
  //   return null;
  // }
}

// static Future<FinanceObject> read(FinanceObject task) async {
//   DatabaseProvider db = DatabaseProvider.instance;
//   FinanceObject loadedTask = await db.query(task.getId());
//   if (loadedTask == null) {
//     //print('failed to load: ${task.getTitle()}');
//   } else {
//     print('loaded: ${loadedTask.getTitle()} @ ${loadedTask.getTime()}');
//   }
//   return loadedTask;
// }
