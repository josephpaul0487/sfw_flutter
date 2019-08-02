
class SfwEntity {
  final List<String> tables;
  final bool needTableMethods;

  const SfwEntity(this.tables,{this.needTableMethods=false}) : assert(tables != null && needTableMethods!=null);
}

class SfwDbConfig {
  final String dbName;
  final int version;
  final String lastDartFileName;
  final int totalFileCount;

  const SfwDbConfig(this.dbName, this.lastDartFileName,this.totalFileCount, {this.version = 1})
      : assert(dbName != null),
        assert(lastDartFileName != null);
}

class SfwDbField {
  final String name;
  final bool isAnEntity;
  final Type genericType;

  const SfwDbField(this.name,{this.isAnEntity=false,this.genericType}) : assert(name != null && name != ''),assert(isAnEntity!=null);
}

class SfwDbExclude {
  final List<String> tables;

  const SfwDbExclude({this.tables : const []}) : assert(tables != null);
}

class SfwDbQuery {
  final Type entityType;
  final bool isList;
  final String table;
  final String where;
  final List<dynamic> whereArgs;
  final int limit;
  final bool distinct;
  final List<String> columns;
  final String groupBy;
  final String having;
  final String orderBy;
  final int offset;

  const SfwDbQuery(this.entityType,this.isList,this.table, { this.where, this.whereArgs, this.limit, this.distinct, this.columns, this.groupBy, this.having, this.orderBy, this.offset})
      : assert(entityType != null),
        assert(table != null && table != '');
}





