/*import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/src/dart/resolver/inheritance_manager.dart'
    show InheritanceManager; // ignore: deprecated_member_use
import 'package:analyzer/dart/constant/value.dart';
import 'reflection.dart';

List<StringBuffer> mainBuffer = [];
StringBuffer createStatements = StringBuffer();
StringBuffer tablesMetaData=StringBuffer();
List<dynamic> tablesMetaDataArgs=[];
StringBuffer dbFunctions = StringBuffer();
Set<String> imports = {};
List<String> typeDefs = [];
//StringBuffer typeDefs = StringBuffer();
const String CLASS_NAME_SUFFIX = "SFW";

String error;

class EntitiesGenerator {
  int i = 0;

  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }

    final classElement = element as ClassElement;

    final helper = _GeneratorHelper();
    final _gen = helper._generate(classElement, annotation, buildStep);

    i++;

    return _gen;
    // return {"// Hey! Annotation found!  $s"};
  }

  static Iterable<FieldElement> createSortedFieldSet(ClassElement element) {
    // Get all of the fields that need to be assigned
    final elementInstanceFields = Map.fromEntries(element.fields
        .where((e) => !e.isStatic && !e.isConst && e.name != "hashCode")
        .map((e) => MapEntry(e.name, e)));

    final inheritedFields = <String, FieldElement>{};
    // ignore: deprecated_member_use
    final manager = InheritanceManager(element.library);

    // ignore: deprecated_member_use
    for (final v in manager.getMembersInheritedFromClasses(element).values) {
      assert(v is! FieldElement);
      if (_dartCoreObjectChecker.isExactly(v.enclosingElement)) {
        continue;
      }

      if (v is PropertyAccessorElement && v.isGetter) {
        assert(v.variable is FieldElement);
        final variable = v.variable as FieldElement;
        assert(!inheritedFields.containsKey(variable.name));
        inheritedFields[variable.name] = variable;
      }
    }

    // Get the list of all fields for `element`
    final allFields =
        elementInstanceFields.keys.toSet().union(inheritedFields.keys.toSet());

    final fields = allFields
        .map((e) => FieldSet(elementInstanceFields[e], inheritedFields[e]))
        .toList();

    // Sort the fields using the `compare` implementation in _FieldSet
    fields.sort();

    return fields.map((fs) => fs.field).toList();
  }
}

class _GeneratorHelper {
  String _generate(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    final sortedFields = EntitiesGenerator.createSortedFieldSet(element);

    // Used to keep track of why a field is ignored. Useful for providing
    // helpful errors when generating constructor calls that try to use one of
    // these fields.
    final unavailableReasons = <String, String>{};

    final accessibleFields = sortedFields.fold<Map<String, FieldElement>>(
        <String, FieldElement>{}, (map, field) {
      if (!field.isPublic) {
        unavailableReasons[field.name] = 'It is assigned to a private field.';
      } else if (field.getter == null) {
        assert(field.setter != null);
        unavailableReasons[field.name] =
            'Setter-only properties are not supported.';
        log.warning('Setters are ignored: ${element.name}.${field.name}');
      }
//      else if (jsonKeyFor(field).ignore) {
//        unavailableReasons[field.name] = 'It is assigned to an ignored field.';
//      }
      else {
        assert(!map.containsKey(field.name));
        map[field.name] = field;
      }

      return map;
    });

    StringBuffer buffer = StringBuffer();

    //IMPORT

    imports.add("import '${element.source.uri}';");

    //CLASS
    buffer.writeln('class ${element.name}$CLASS_NAME_SUFFIX {');

    //TABLE NAMES TO STATIC FIELDS
    List<DartObject> tables = annotation.read('tables').listValue;
    tables.forEach((dart) {
      buffer.writeln(
          "static const ${dart.toStringValue().toUpperCase()} = '${dart.toStringValue()}';");
    });

    //CALLBACK FUNCTIONS
    if (!typeDefs.contains(
        'typedef ${element.name}CallBack = void Function(${element.name} model);'))
      typeDefs.add(
          'typedef ${element.name}CallBack = void Function(${element.name} model);');
    if (!typeDefs.contains(
        'typedef ${element.name}ListCallBack = void Function(List<${element.name}> models);'))
      typeDefs.add(
          'typedef ${element.name}ListCallBack = void Function(List<${element.name}> models);');

    //FUNCTION FOR get and set Object from and to Map

    buffer.writeln(
        '    static Map<String, dynamic> toJson(${element.name} model, {List<String> columns,String table,bool toDatabase=true}) {');
    buffer.writeln('if (columns == null || columns.isEmpty)');
    buffer.writeln('{');
    buffer.writeln('Map<String,dynamic> json={};');

    StringBuffer fromJson = StringBuffer(
        '    static ${element.name} fromJson(Map<String, dynamic> json, {List<String> columns,bool fromDatabase=true}) {');
    StringBuffer jsonToJson=StringBuffer(
        '    static Map<String,dynamic> jsonToJson(Map<String,dynamic> mapToCheck,  {List<String> columns,String table}) {');
    jsonToJson.writeln('');
    jsonToJson.writeln('if (mapToCheck == null )');
    jsonToJson.writeln("return {};");
    jsonToJson.writeln('if ((columns == null || columns.isEmpty)  && (table==null || table.trim()=="") )');
    jsonToJson.writeln("return mapToCheck;");
    jsonToJson.writeln('if (columns == null || columns.isEmpty)');
    jsonToJson.writeln('{');
    jsonToJson.writeln('Map<String,dynamic> json={};');

    StringBuffer jsonToJsonList=StringBuffer(
        '    static List<dynamic> jsonToJsonList(List<dynamic> listToCheck,  {List<String> columns,String table}) {');
    jsonToJsonList.writeln('');
    jsonToJsonList.writeln('if (listToCheck == null )');
    jsonToJsonList.writeln("return [];");
    jsonToJsonList.writeln('if ((columns == null || columns.isEmpty)  && (table==null || table.trim()=="") )');
    jsonToJsonList.writeln("return listToCheck;");
    jsonToJsonList.writeln('List< dynamic> list = [];');
    jsonToJsonList.writeln('listToCheck.forEach((item) {');
    jsonToJsonList.writeln('list.add(jsonToJson(item,columns:columns,table:table));');
    jsonToJsonList.writeln('});');
    jsonToJsonList.writeln('return list;');
    jsonToJsonList.writeln('}');
    jsonToJsonList.writeln('');

    fromJson.writeln('');
    fromJson.writeln('if (columns == null || columns.isEmpty)');
//    fromJson.writeln('return ${element.name}()');
    fromJson.write('return ${element.name}(');

    //END OF To Json and From Json Functions
    //return model object if columns are not empty (fromJson function)
//    StringBuffer fromJson2 = StringBuffer('return ${element.name}()');
    StringBuffer fromJsonByColumns = StringBuffer('return ${element.name}(');

    StringBuffer fields = StringBuffer();

    StringBuffer getter = StringBuffer();
    getter.write(
        'static dynamic get(${element.name} model,String fieldName,{bool toJson=true}) {');
    getter.writeln('switch(fieldName) {');
    //FIELDS
    int i = 0;
    // List<SfwDbField> dbFields=[];
    //LOOP
    accessibleFields.forEach((str, e) {
      final annotationDbExclude = annotationForDbExclude(e);
      List<DartObject> excluded = annotationDbExclude != null
          ? annotationDbExclude.getField('tables').toListValue()
          : [];

      if (annotationDbExclude != null &&
          excluded.length == 0) //Excluded for all tables
        return;

      String dbFieldName = str;
      final annotation = annotationForDbName(e);
      bool isAnEntity = false;
      String genericType;
      bool isList=e.type.name == "List";
      bool isMap=e.type.name == "Map";
      StringBuffer excludedTables = StringBuffer();

      //excluded tables condition
      if (excluded.length > 0) excludedTables.write('if(');
      int j = 0;
      excluded.forEach((e) {
        if (j != 0) excludedTables.write(' && ');
        j++;
        excludedTables.write(
            'table != ${e.toStringValue() == null ? 'null' : '"${e.toStringValue()}"'}');
      });
      if (excluded.length > 0) excludedTables.write(')');
     // isFieldContains.writeln()

      if (annotation != null) {
        dbFieldName = annotation.getField('name').toStringValue();
        isAnEntity = annotation.getField("isAnEntity").toBoolValue();
        isAnEntity = annotation.getField("isAnEntity").toBoolValue();
        genericType = annotation.getField("genericType").toTypeValue()?.name;


      }
      if(isList && (genericType==null || genericType=="")) {
        error =
        'A custom List field should provide getnericType value.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}   FIELD : ${e.name}';
        throw InvalidGenerationSourceError(
            'A custom List field should provide getnericType value.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}   FIELD : ${e.name}',
            element: element);
      }

//      fromJson.writeln("   ..$str= json['$dbFieldName'] as ${e.type}");
      if (i != 0) {
        fromJson.write(", ");
        fromJsonByColumns.write(", ");
      }

      switch (e.type.name) {
        case 'bool':
          fromJson.write("$str: json.containsKey('$dbFieldName')? json['$dbFieldName'] == 1 : false");
          fromJsonByColumns.write(
              "$str: (columns.contains('$dbFieldName')&& json.containsKey('$dbFieldName') ? json['$dbFieldName'] : null) == 1");
          buffer.write(
              " ${excludedTables.toString()}  json['$dbFieldName'] = model.$str==true?1:0;");

          break;
        case 'int':
        case 'double':
        case 'String':
          fromJson.write("$str:json.containsKey('$dbFieldName')? json['$dbFieldName'] as ${e.type} : null");
          fromJsonByColumns.write(
              "$str: (columns.contains('$dbFieldName') && json.containsKey('$dbFieldName') ? json['$dbFieldName'] : null) as ${e.type}");
          buffer.write(
              " ${excludedTables.toString()}  json['$dbFieldName'] = model.$str;");

          break;
        default:
          String decode;
          String encode;
          if (isAnEntity) {
            encode =
            isList?" ${genericType}SFW.toJsonList(model.$str) ":  "${genericType}SFW.toJson(model.$str)";
            encode="toDatabase?JSON.json.encode($encode):$encode";
            decode="json.containsKey('$dbFieldName') ? (fromDatabase?JSON.json.decode(json['$dbFieldName']):json['$dbFieldName']):null";
            decode =
            isList?"${genericType}SFW.fromJsonList($decode)" :  "${genericType}SFW.fromJson($decode)";

          } else {
              if(isMap || (isList && (genericType=="int" || genericType=="String" || genericType=="double" || genericType=="bool" || genericType=="Map" || genericType=="List"))) {
                decode='JSON.json.decode(json["$dbFieldName"])';
                encode = "JSON.json.encode(model.$str)";
              } else {
                String fieldName=e.name.replaceRange(0, 1, e.name.substring(0,1).toUpperCase());
                decode =
                "${element.name}.decode$fieldName(${isList || isMap ? 'json["$dbFieldName"]': 'JSON.json.decode(json["$dbFieldName"] as String)'}  )";
                encode = "${element.name}.encode$fieldName(model.$str)";
              }


          }
          fromJson.write("$str: json['$dbFieldName']==null ? null: $decode");
          fromJsonByColumns.write(
              "$str: columns.contains('$dbFieldName') && json.containsKey('$dbFieldName') && json['$dbFieldName'] != null ? $decode : null");

          buffer.write(
              " ${excludedTables.toString()}  json['$dbFieldName'] = model.$str==null?null:$encode;");

          break;
      }
      jsonToJson.write(
          " ${excludedTables.toString()} json['$dbFieldName'] = mapToCheck.containsKey('$dbFieldName')? mapToCheck['$dbFieldName']:null;");

      //TABLE CREATE STATEMENT

      bool getterFiledSet = false;

      if (dbFieldName != 'id') {
        if (fields.length > 0) fields.write(', ');
        fields.write('$dbFieldName ');
        switch (e.type.name) {
          case 'bool':
          case 'int':
            fields.write("INTEGER");
            break;

          case 'double':
            fields.write("REAL");
            break;
          case 'String':
            fields.write("TEXT");
            break;
          default:
            getterFiledSet=true;
            getter.writeln('case "${e.name}":');
            getter.writeln('if(toJson) {');
            if(isAnEntity)
            getter.writeln(' return JSON.json.encode(${isList ? "${genericType}SFW.toJsonList(model.${e.name})":"${genericType}SFW.toJson(model.${e.name})"});');
            else if(isMap || (isList && (genericType=="int" || genericType=="String" || genericType=="double" || genericType=="bool" || genericType=="Map" || genericType=="List"))) {
              getter.writeln('return JSON.json.encode(model.${e.name});');
            } else {
              String fieldName=e.name.replaceRange(0, 1, e.name.substring(0,1).toUpperCase());
              getter.writeln('return $genericType.encode$fieldName(model.${e.name});');
            }
            getter.writeln('}');
            getter.writeln(' return model.${e.name};');
            fields.write("TEXT");
            break;
        }
      }
      if (!getterFiledSet)
        getter.writeln('case "${e.name}": return model.${e.name};');
      i++;
    });
    //END LOOP

    if (tables.length == 0) {
      if (element.name == CLASS_NAME_SUFFIX.toLowerCase()) {
        error =
            'Generator cannot  create table "${element.name}". This table name is reserved.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}';
        throw InvalidGenerationSourceError(
            'Generator cannot target create table "${element.name}". This table name is reserved.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}',
            element: element);
      }
      createStatements.writeln(
          "_batch.execute('CREATE TABLE IF NOT EXISTS ${element.name} (id INTEGER PRIMARY KEY,${fields.toString()})');");
      if(tablesMetaData.length>0)
        tablesMetaData.write(",");
      tablesMetaData.write("(?,?)");
      tablesMetaDataArgs.add('"${element.name}"');
      tablesMetaDataArgs.add('"id INTEGER PRIMARY KEY,${fields.toString()}"');

//      createStatements.writeln(
//          "await transaction.execute('CREATE TABLE IF NOT EXISTS ${element.name} (id INTEGER PRIMARY KEY,${fields.toString()})');");
    } else {
      tables.forEach((dart) {
        if (dart.toStringValue().toLowerCase() ==
            CLASS_NAME_SUFFIX.toLowerCase()) {
          error =
              'Generator cannot  create table "${dart.toStringValue()}". This table name is reserved.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}';
          throw InvalidGenerationSourceError(
              'Generator cannot target create table "${dart.toStringValue()}". This table name is reserved.  Found in  :  CLASS -> "${element.name}"  FILE -> ${element.source.fullName}',
              element: element);
        }
//        createStatements.writeln(
//            "await transaction.execute('CREATE TABLE IF NOT EXISTS ${dart.toStringValue()} (id INTEGER PRIMARY KEY,${fields.toString()})');");
        createStatements.writeln(
            "_batch.execute('CREATE TABLE IF NOT EXISTS ${dart.toStringValue()} (id INTEGER PRIMARY KEY,${fields.toString()})');");
        if(tablesMetaData.length>0)
          tablesMetaData.write(",");
        tablesMetaData.write("(?,?,?,?)");
        tablesMetaDataArgs.add('"${dart.toStringValue()}"');
        tablesMetaDataArgs.add('"id INTEGER PRIMARY KEY,${fields.toString()}"');
        tablesMetaDataArgs.add('createdAt');
        tablesMetaDataArgs.add('createdAt');
      });
    }
    //END OF CREATE TABLES

    getter.writeln('}');
    getter.writeln('}');
    buffer.writeln('    return json;');
    buffer.writeln(' }');
    buffer.writeln('Map<String, dynamic> map = {};');
    buffer.writeln('columns.forEach((column) {');
    buffer.writeln('map[column] = get(model, column);');
    buffer.writeln('});');
    buffer.writeln('return map;');
    buffer.writeln('}');

    jsonToJson.writeln('    return json;');
    jsonToJson.writeln(' }');
    jsonToJson.writeln('Map<String, dynamic> map = {};');
    jsonToJson.writeln('columns.forEach((column) {');
    jsonToJson.writeln('map[column] = mapToCheck[column];');
    jsonToJson.writeln('});');
    jsonToJson.writeln('return map;');
    jsonToJson.writeln('}');

    fromJson.write(');');
//    fromJson.write(';');
    fromJsonByColumns.write(');');

    buffer.writeln(fromJson);
    buffer.writeln(fromJsonByColumns);
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln(jsonToJson);
    buffer.writeln(jsonToJsonList);
    buffer.writeln('');
    buffer.writeln(
        'static List<${element.name}> fromJsonList(List<dynamic> data, {List<String> columns, bool fromDatabase = true}) {');
    buffer.writeln('List<${element.name}> list=[];');
    buffer.writeln('data.forEach((g){');
    buffer.writeln('list.add(${element.name}SFW.fromJson(g as Map,fromDatabase:fromDatabase,columns:columns));');
    buffer.writeln('});');
    buffer.writeln('return list;');
    buffer.writeln('}');

    buffer.writeln('');
    buffer.writeln(
        'static List<dynamic> toJsonList(List<${element.name}> data, {List<String> columns,bool toDatabase=true}) {');
    buffer.writeln('List<dynamic> list=[];');
    buffer.writeln('data.forEach((g){');
    buffer.writeln('list.add(${element.name}SFW.toJson(g,columns:columns,toDatabase:toDatabase));');
    buffer.writeln('});');
    buffer.writeln('return list;');
    buffer.writeln('}');

    buffer.writeln('');
    buffer.writeln(getter);

    //DB functions
    _createDbFunctions(element, annotation, buffer);
    //END OF DB functions

    buffer.writeln('}');

    mainBuffer.add(buffer);
    //_addedMembers.add(buffer.toString());
    return "";
  }
}

_createDbFunctions(
    ClassElement element, ConstantReader annotation, StringBuffer buffer) {
  List<DartObject> tables = annotation.read('tables').listValue;
  String generatedClassName = '${element.name}$CLASS_NAME_SUFFIX';

  //GET SINGLE
  buffer.writeln(
      'static Future<${element.name}> getSingle(String table,${element.name}CallBack callback,{bool distinct : false,List<String> columns,String where, List<dynamic> whereArgs, String groupBy, String having,String orderBy, int offset}) async {');
  buffer.writeln('if(callback != null) {');
  buffer.writeln(
      'DBProvider.getInstance().query(table,limit: 1,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset).then((value){');
  //buffer.writeln('if(callback!=null) {');
  buffer.writeln('callback(value.isNotEmpty ? fromJson(value.first) : null);');
  //buffer.writeln('}');
  buffer.writeln('});');
  buffer.writeln('return null;');
  buffer.writeln('}');
  buffer.writeln(
      'List<Map<String,dynamic>> value=await DBProvider.getInstance().query(table,limit: 1,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset);');
  buffer.writeln('return value.isNotEmpty ? fromJson(value.first) : null;');
  buffer.writeln('}');
  buffer.writeln('');

  //GET ALL
  buffer.writeln(
      'static Future<List<${element.name}>> getAll(String table,${element.name}ListCallBack callback,{bool distinct: false,List<String> columns,String where, List<dynamic> whereArgs, String groupBy, String having,String orderBy,int limit, int offset}) async {');
  buffer.writeln('if(callback != null) {');
  buffer.writeln(
      'DBProvider.getInstance().query(table,limit: limit,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset).then((value){');
  buffer.writeln('List<${element.name}> data=[];');
  buffer.writeln('value.forEach((map){');
  buffer.writeln('data.add($generatedClassName.fromJson(map));');
  buffer.writeln('});');
  buffer.writeln('callback(data);');
  buffer.writeln('});');
  buffer.writeln('return [];');
  buffer.writeln('}');
  buffer.writeln(
      'List<Map<String,dynamic>> value= await DBProvider.getInstance().query(table,limit: limit,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset);');
  buffer.writeln('List<${element.name}> data=[];');
  buffer.writeln('value.forEach((map){');
  buffer.writeln('data.add($generatedClassName.fromJson(map));');
  buffer.writeln('});');
  buffer.writeln('return data;');
  buffer.writeln('}');
  buffer.writeln('');

  //INSERT
  buffer.writeln(
      'static Future<int> insert(String table,{${element.name} model,Map<String,dynamic> jsonModel,String jsonString,bool useAsync=false,String nullColumnHack, ConflictAlgorithm conflictAlgorithm=ConflictAlgorithm.ignore,IntCallBack callback}) async { ');
  buffer.writeln('if(callback != null)');
//  buffer.writeln(
//      'DBProvider.getInstance().insert(table,model!=null?$generatedClassName.toJson(model,table:table):null,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm).then(callback);');
  buffer.writeln(
      'DBProvider.getInstance().insert(table,model!=null?$generatedClassName.toJson(model,table:table):$generatedClassName.jsonToJson(jsonModel!=null?jsonModel:jsonString) ,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm).then(callback);');
  buffer.writeln('else if(useAsync) {');
  buffer.writeln(
      'return await DBProvider.getInstance().insert(table,model!=null?$generatedClassName.toJson(model,table:table):$generatedClassName.jsonToJson(jsonModel!=null?jsonModel:jsonString),nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm);');
  buffer.writeln('}');
  buffer.writeln('else');
  buffer.writeln(
      'DBProvider.getInstance().insert(table,$generatedClassName.toJson(model,table:table),nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm);');

  buffer.writeln('return 0;');
  buffer.writeln('}');
  buffer.writeln('');

  //INSERT LIST
  buffer.writeln(
      'static Future<int> insertAll(String table,{List<${element.name}> models,List<dynamic> jsonList,String jsonStringList,String nullColumnHack, ConflictAlgorithm conflictAlgorithm=ConflictAlgorithm.ignore,IntCallBack callback,bool useAsync=false}) async { ');
  buffer.writeln('int inserted=0;');
  buffer.writeln('IntCallBack other= callback==null?null:(value){');
  buffer.writeln('if(value>0)');
  buffer.writeln('++inserted;');
  buffer.writeln('};');
  buffer.writeln('(models!=null?models:jsonList!=null?jsonList:JSON.json.decode(jsonStringList)).forEach((model) async {');
  buffer.writeln('if(callback!=null || !useAsync)');
  buffer.writeln(
      ' insert(table,model:models==null?null:model,jsonModel:models==null?model:null,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:other);');
  buffer.writeln('else {');
  buffer.writeln(
      ' int id= await insert(table,model:models==null?null:model,jsonModel:models==null?model:null,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:other);');
  buffer.writeln('if(id>0) ');
  buffer.writeln('++inserted; ');
  buffer.writeln('} ');
  buffer.writeln('}); ');
  buffer.writeln('if(callback!=null) {');
  buffer.writeln("callback(inserted);");
  buffer.writeln("}");
  buffer.writeln("return inserted;");
  buffer.writeln("}");
  buffer.writeln('');

  //DELETE ALL TABLES

  buffer.writeln(
      'static Future<void> deleteAllTables({String where, List<dynamic> whereArgs,bool useAsync=false,List<String> excludedTables=const []}) async { ');
  buffer.writeln("Batch _batch=DBProvider.getInstance().getBatch();");//BATCH

  tables.forEach((dart) {

    buffer.writeln('if(!excludedTables.contains("${dart.toStringValue().toLowerCase()}"))');
    buffer.writeln(
        '_batch.delete("${dart.toStringValue().toLowerCase()}",where:where,whereArgs:whereArgs);');


  });
  buffer.writeln("if(useAsync) {");//START CALLBACK ASYNC
  buffer.writeln("await _batch.commit();");//BATCH COMMIT WITH AWAIT
  buffer.writeln("}");//ASYNC END
  buffer.writeln("else {");//ASYNC ELSE
  buffer.writeln("_batch.commit();");//BATCH COMMIT WITHOUT AWAIT
  buffer.writeln("}");// ASYNC ELSE END


  buffer.writeln('}');//END OF DELETE ALL
  buffer.writeln('');

  //DELETE
  buffer.writeln(
      'static Future<int> delete(String table,{String where, List<dynamic> whereArgs,IntCallBack callback,bool useAsync=false}) async { ');
  buffer.writeln("if(callback != null)");
  buffer.writeln(
      'DBProvider.getInstance().delete(table,where:where,whereArgs:whereArgs).then(callback);');
  buffer.writeln("else if(useAsync)");
  buffer.writeln(
      'return await DBProvider.getInstance().delete(table,where:where,whereArgs:whereArgs);');
  buffer.writeln(
      'DBProvider.getInstance().delete(table,where:where,whereArgs:whereArgs);');
  buffer.writeln('return 0;');
  buffer.writeln('}');
  buffer.writeln('');

  //DELETE BY COLUMNS
  buffer.writeln(
      'static Future<int> deleteByColumn(String table,${element.name} model,List<String> columns,{String operator:" AND ",IntCallBack callback,bool useAsync=false}) async { ');
  buffer.writeln('String where="";');
  buffer.writeln('List<dynamic> whereArgs=[];');
  buffer.writeln('columns.forEach((column){');
  buffer.writeln('if(where.length>0) where+=operator;');
  buffer.writeln('where+=" \$column=? ";');
  buffer.writeln(
      'whereArgs.add(${element.name}$CLASS_NAME_SUFFIX.get( model,column));');
  buffer.writeln('});');
  buffer.writeln('if(useAsync)');
  buffer.writeln(
      'return await delete(table,where:where,whereArgs:whereArgs,callback:callback,useAsync:true);');
  buffer.writeln(
      'return delete(table,where:where,whereArgs:whereArgs,callback:callback);');
  buffer.writeln('}');
  buffer.writeln('');

  //UPDATE
  buffer.writeln(
      'static Future<int> update(String table,${element.name} model, {List<String> columns,String where, List<dynamic> whereArgs, ConflictAlgorithm conflictAlgorithm : ConflictAlgorithm.replace,IntCallBack callback,bool useAsync=false}) async { ');
  buffer.writeln("if(where==null || where.isEmpty) {");
  buffer.writeln('where = "id=?";');
  buffer.writeln('whereArgs=[model.id];');
  buffer.writeln('}');
  buffer.writeln('if(callback !=null)');
  buffer.writeln(
      'DBProvider.getInstance().update(table, ${element.name}SFW.toJson(model,table:table,columns: columns),conflictAlgorithm: conflictAlgorithm,whereArgs: whereArgs,where: where).then(callback);');
  buffer.writeln('else if(useAsync)');
  buffer.writeln(
      'return await DBProvider.getInstance().update(table, ${element.name}SFW.toJson(model,table:table,columns: columns),conflictAlgorithm: conflictAlgorithm,whereArgs: whereArgs,where: where);');
  buffer.writeln('else');
  buffer.writeln(
      'DBProvider.getInstance().update(table, ${element.name}SFW.toJson(model,table:table,columns: columns),conflictAlgorithm: conflictAlgorithm,whereArgs: whereArgs,where: where);');
  buffer.writeln("return 0;");
  buffer.writeln("}");
  buffer.writeln('');



  if(annotation.read("needTableMethods").boolValue) {
    //LOOP START
    tables.forEach((dart) {
      String table = dart.toStringValue().toLowerCase();
      String tableToUpper = '${table[0].toUpperCase()}${table.substring(1)}';

      //GET SINGLE TO ALL TABLES
      buffer.writeln(
          'static Future<${element.name}> getFrom${tableToUpper}Table(${element
              .name}CallBack callback,{bool distinct : false,List<String> columns,String where, List<dynamic> whereArgs, String groupBy, String having,String orderBy, int offset}) async {');
      buffer.writeln('if(callback == null)');
      buffer.writeln(
          'return await getSingle("$table",callback,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset);');
      buffer.writeln(
          'getSingle("$table",callback,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,offset:offset);');
      buffer.writeln('return null;');
      buffer.writeln('}');
      buffer.writeln('');

      //GET ALL FROM ALL TABLES
      buffer.writeln(
          'static Future<List<${element
              .name}>>  getAllFrom${tableToUpper}Table(${element
              .name}ListCallBack callback,{bool distinct: false,List<String> columns,String where, List<dynamic> whereArgs, String groupBy, String having,String orderBy,int limit, int offset}) async {');
      buffer.writeln('if(callback == null)');
      buffer.writeln(
          'return await getAll("$table",callback,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,limit:limit,offset:offset);');
      buffer.writeln(
          'getAll("$table",callback,distinct:distinct ?? false,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,limit:limit,offset:offset);');
      buffer.writeln('return [];');
      buffer.writeln('}');
      buffer.writeln('');

      //INSERT SINGLE TO ALL TABLES
      buffer.writeln(
          'static Future<int> insertTo${tableToUpper}Table({${element
              .name} model,Map<String,dynamic> jsonModel,String jsonString,String nullColumnHack, ConflictAlgorithm conflictAlgorithm=ConflictAlgorithm.ignore,IntCallBack callback,useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          "return await insert('$table',model:model,jsonModel:jsonModel,jsonString:jsonString,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:callback,useAsync:true);");
      buffer.writeln(
          "return insert('$table',model:model,jsonModel:jsonModel,jsonString:jsonString,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:callback);");
      buffer.writeln('}');
      buffer.writeln('');

      //INSERT LIST TO ALL TABLES
      buffer.writeln(
          'static Future<int> insertAllTo${tableToUpper}Table({List<${element
              .name}> models,List<dynamic> jsonList,String jsonStringList,String nullColumnHack, ConflictAlgorithm conflictAlgorithm=ConflictAlgorithm.ignore,IntCallBack callback,useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          'return await insertAll("$table",models:models,jsonList:jsonList,jsonStringList:jsonStringList,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:callback,useAsync:true);');
      buffer.writeln(
          'return insertAll("$table",models:models,jsonList:jsonList,jsonStringList:jsonStringList,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm,callback:callback);');
      buffer.writeln('}');
      buffer.writeln('');

      //DELETE BY ID
      buffer.writeln(
          'static Future<int> deleteFrom${tableToUpper}TableById(${element
              .name} model,{IntCallBack callback,useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          'return await deleteFrom${tableToUpper}Table(where:"id=?",whereArgs:[model.id],callback:callback,useAsync:true);');
      buffer.writeln(
          'return deleteFrom${tableToUpper}Table(where:"id=?",whereArgs:[model.id],callback:callback);');
      buffer.writeln('}');
      buffer.writeln('');

      //DELETE BY COLUMNS FROM ALL TABLES
      buffer.writeln(
          'static Future<int> deleteFrom${tableToUpper}TableByColumn(${element
              .name} model,List<String> columns,{String operator:" AND ",IntCallBack callback,useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          'return await deleteByColumn("$table",model,columns,operator:operator,callback:callback,useAsync:true);');
      buffer.writeln(
          'return deleteByColumn("$table",model,columns,operator:operator,callback:callback);');
      buffer.writeln('}');
      buffer.writeln('');

      //DELETE
      buffer.writeln(
          'static Future<int> deleteFrom${tableToUpper}Table({String where, List<dynamic> whereArgs,IntCallBack callback,bool useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          'return await delete("$table",where:where,whereArgs:whereArgs,callback:callback,useAsync:true);');
      buffer.writeln(
          'return delete("$table",where:where,whereArgs:whereArgs,callback:callback);');
      buffer.writeln('}');
      buffer.writeln('');

      //UPDATE
      buffer.writeln(
          'static Future<int> updateTo${tableToUpper}Table(${element
              .name} model,{List<String> columns,ConflictAlgorithm conflictAlgorithm=ConflictAlgorithm.replace,String where, List<dynamic> whereArgs,IntCallBack callback,bool useAsync=false}) async { ');
      buffer.writeln('if(callback == null && useAsync)');
      buffer.writeln(
          "return await update('$table',model,columns:columns,conflictAlgorithm:conflictAlgorithm,where:where,whereArgs:whereArgs,callback:callback,useAsync:true);");
      buffer.writeln(
          "return update('$table',model,columns:columns,conflictAlgorithm:conflictAlgorithm,where:where,whereArgs:whereArgs,callback:callback);");
      buffer.writeln('}');
      buffer.writeln('');
    }); //loop end
  }
}

const _dartCoreObjectChecker = TypeChecker.fromRuntime(Object);*/
