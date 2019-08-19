
class SfwEntity {
  final List<String> tables;
  final bool needTableMethods;
  final bool isAnDbEntity;

  const SfwEntity(this.tables,{this.needTableMethods=false,this.isAnDbEntity=true}) : assert(tables != null && needTableMethods!=null);
}

class SfwDbConfig {
  final String dbName;
  final int version;
  final int totalFileCount;

  const SfwDbConfig(this.dbName, this.totalFileCount, {this.version = 1})
      : assert(dbName != null),
        assert(totalFileCount != null && totalFileCount>0),assert(version!=null && version>0);
}

class SfwDbField {
  final String name;
  final bool isAnEntity;
  final Type genericType;
  final bool isUnique;
  final bool canNull;


  const SfwDbField({this.name,this.isAnEntity=false,this.genericType,this.isUnique=false,this.canNull=true}) : assert(name != null && name != ''),assert(isAnEntity!=null),assert(isUnique!=null),assert(canNull!=null);
}

class SfwDbPrimary {
  const SfwDbPrimary();
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





