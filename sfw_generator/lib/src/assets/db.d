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
      await SfwConfigDb.SFW_CONFIG_CLASS.onOpen(db);
    },
        onCreate: (Database db, int version) async {
          await _createDb(db, version);
          await SfwConfigDb.SFW_CONFIG_CLASS.onCreate( db, version);
        }, onUpgrade: (db, version, newVersion) async {
          List<Map<String, dynamic>> tables = await db.query("sfwMeta");
          for (final tableData in tables) {
            if (!_tableDetails.contains(tableData[''])) {
              await db.execute("DROP TABLE ${tableData['']}");
            }
          }
          await _createDb(db, version);
          await SfwConfigDb.SFW_CONFIG_CLASS.onUpgrade( db, version, newVersion);
        },onDowngrade: (db, version, newVersion) async {
          List<Map<String, dynamic>> tables = await db.query("sfwMeta");
          for (final tableData in tables) {
            if (!_tableDetails.contains(tableData[''])) {
              await db.execute("DROP TABLE ${tableData['']}");
            }
          }
          await _createDb(db, version);
          await SfwConfigDb.SFW_CONFIG_CLASS.onDowngrade( db, version, newVersion);
        });
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