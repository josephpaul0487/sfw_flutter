class DBProvider {
  static Database _db;
  static DBProvider _provider;
  static DBProvider getInstance({VoidCallback callback}) {
    if (_provider == null) _provider = DBProvider(callback: callback);
    if (callback != null && _db != null) callback();
    return _provider;
  }

  DBProvider({VoidCallback callback}) {
    if (callback != null)
      _initDataBase().then((value) {
        callback();
      });
    else
      _initDataBase();
  }
  _initDataBase() async {
    if (_db == null) _db = await _initDB();
  }

  _initDB() async {
    String dbFolder = await getDatabasesPath();
    String path = join(dbFolder, 'dbName');
    List<String> _tableDetails = TABLE_DETAILS;
    return await openDatabase(path, version: dbVersion, onOpen: (db) async {
      await _callMethod(SFW_CONFIG_CLASS.onCreate, db, 0, 0,passVersion:false);
    },
        onCreate: (Database db, int version) async {
          await _createDb(db, version);
          await _callMethod(SFW_CONFIG_CLASS.onCreate, db, version, version,passNewVersion:false);
        }, onUpgrade: (db, version, newVersion) async {
          List<Map<String, dynamic>> tables = await db.query("sfwMeta");
          for (final tableData in tables) {
            if (!_tableDetails.contains(tableData[''])) {
              await db.execute("DROP TABLE ${tableData['']}");
            }
          }
          await _createDb(db, version);
          await _callMethod(SFW_CONFIG_CLASS.onUpgrade, db, version, newVersion);
        },onDowngrade: (db, version, newVersion) async {
          List<Map<String, dynamic>> tables = await db.query("sfwMeta");
          for (final tableData in tables) {
            if (!_tableDetails.contains(tableData[''])) {
              await db.execute("DROP TABLE ${tableData['']}");
            }
          }
          await _createDb(db, version);
          await _callMethod(SFW_CONFIG_CLASS.onDowngrade, db, version, newVersion);
        });
  }

  _callMethod(Function f, Database db, int oldVersion, int newVersion,{bool passNewVersion=true,bool passVersion=true}) async {
    try {
      if(passNewVersion && passVersion)
        await f(db,oldVersion,newVersion);
      else if(passVersion)
        await f(db,oldVersion);
      else
        await f(db);
    } catch (e) {
      throw Exception(
          "You should create following methods in your SFW_CONFIG_CLASS . 1.. Future onCreate(Database db, int version) async {}  2.. Future onUpgrade(Database db, int oldVersion, int newVersion) async{} 3.. Future onOpen(Database db) async {} 4.. Future onDowngrade(Database db, int oldVersion, int newVersion) async{}");
    }
  }

  _createDb(Database db, int version) async {
    Batch _batch = db.batch();
    dbTransaction
    await _batch.commit(noResult: true);
  }

  Batch getBatch() => _db.batch();
  Future<int> rawDelete(String sql, [List<dynamic> arguments]) async =>
      await _db.rawDelete(sql, arguments);

  Future<int> delete(String table, {String where, List<dynamic> whereArgs}) async =>
      await _db.delete(table, where: where, whereArgs: whereArgs);

  Future<void> execute(String sql, [List<dynamic> arguments]) async =>
      await _db.execute(sql, arguments);

  Future<int> rawInsert(String sql, [List<dynamic> arguments]) async =>
      await _db.rawInsert(sql, arguments);

  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async =>
      await _db.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct = false,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset}) async =>
      await _db.query(table,
          distinct: distinct == null ? false : distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic> arguments]) async =>
      await _db.rawQuery(sql, arguments);

  Future<int> rawUpdate(String sql, [List<dynamic> arguments]) async =>
      await _db.rawUpdate(sql, arguments);

  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
        List<dynamic> whereArgs,
        ConflictAlgorithm conflictAlgorithm}) async =>
      await _db.update(table, values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);
}