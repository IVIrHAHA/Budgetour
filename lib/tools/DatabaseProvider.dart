import 'dart:async';
import 'package:budgetour/models/BudgetourReserve.dart' as br;
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
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
    print('DB-PROCESS: INITIALIZING DATABASE');
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

    // CashHandler Table
    creationBatch.execute("CREATE TABLE ${DbNames.ch_TABLE}("
        "${DbNames.ch_TransactionLink} REAL PRIMARY KEY,"
        "${DbNames.ch_CashReserve} REAL"
        ")");

    await creationBatch.commit();
  }

  Future<int> insert(Object object) async {
    // Connect to database
    Database db = await database;

    // Trying to save a FinanceObject
    if (object is FinanceObject) {
      int id = await db.insert(DbNames.fo_TABLE, object.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      return id;
    }

    // Trying to save a CashHandler
    else if (object is br.CashHandler) {
      int id = await db.insert(DbNames.ch_TABLE, object.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      return id;
    }

    // Trying to save a Transaction
    else if (object is br.Transaction) {
      int id = await db.insert(DbNames.trxt_TABLE, object.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      return id;
    } else {
      throw Exception('Not a valid dbase insert query');
    }
  }

  Future<int> getTransactionQty() async {
    Database db = await database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM ${DbNames.trxt_TABLE}"));
    return count;
  }

  Future<List<Map>> loadAllHolders() async {
    Database db = await database;
    List<Map> mapList = await db.rawQuery("SELECT * FROM ${DbNames.fo_TABLE}");

    if (mapList.length > 0) {
      return mapList;
    }  else {
        print('DB-PROCESS: NO FINANCE OBJECTS TO LOAD');
      }
    return null;
  }

  Future<Map> loadCOH(double id) async {
    Database db = await database;
    List<Map> list = await db.query(
      DbNames.ch_TABLE,
      columns: [DbNames.ch_TransactionLink, DbNames.ch_CashReserve],
      where: "${DbNames.ch_TransactionLink} = ?",
      whereArgs: [id],
    );

    if (list.length > 0) {
      return list.first;
    } 
    /// No data was saved yet
    else {
      await insert(CashOnHand.instance).whenComplete(() {
        print('DB-PROCESS: INITIALIZED CASH ON HAND INTO DATABASE');
      });
      return CashOnHand.instance.toMap();
    }
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
      print('DB-PROCESS: NO TRANSACTIONS IN ${DbNames.trxt_TABLE}');
      return List();
    }
  }
}
