import 'dart:async';

import 'package:analyzer/dart/constant/value.dart' show DartObject;
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:sfw_imports/sfw_imports.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart';
import 'entity.dart' as entityGenerator;

int totalElements = 0;
List<StringBuffer> _mainBuffer = [];
Set<String> _imports = {};
//String lastDartFileName = "";
StringBuffer _dbBuffer = StringBuffer();
StringBuffer queryBuffer = StringBuffer();
StringBuffer webQueryBuffer = StringBuffer();
StringBuffer webConfigBuffer = StringBuffer();
int filesFinished=0;
int totalFileCount=-1;

//flutter packages pub run build_runner clean
//flutter packages pub run build_runner build
//flutter packages pub run build_runner build --delete-conflicting-outputs
class DbGenerator extends Generator {
  final _jsonWebCallChecker = TypeChecker.fromRuntime(SfwWebCall);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {

    ++filesFinished;
    log.warning("FILE :  ${library.element.source.shortName}  finishedFileCount = $filesFinished");

    final values = Set<String>();
    entityGenerator.EntitiesGenerator entities =
        entityGenerator.EntitiesGenerator();
    for (var annotatedElement
        in library.annotatedWith(TypeChecker.fromRuntime(SfwEntity))) {
      entities.generateForAnnotatedElement(
          annotatedElement.element, annotatedElement.annotation, buildStep);
    }

    _imports.addAll(entityGenerator.imports);

    _mainBuffer.addAll(entityGenerator.mainBuffer);
    entityGenerator.imports.clear();
    entityGenerator.mainBuffer.clear();
    if (totalFileCount == -1) {
      for (var annotatedElement
          in library.annotatedWith(TypeChecker.fromRuntime(SfwDbConfig))) {
        String query = generateForAnnotatedElement(
            annotatedElement.element, annotatedElement.annotation, buildStep);
//        lastDartFileName =
//            annotatedElement.annotation.read('lastDartFileName').stringValue;
        totalFileCount =
            annotatedElement.annotation.read('totalFileCount').intValue;

        queryBuffer.clear();
        queryBuffer.writeln('class ${annotatedElement.element.name} {');
        queryBuffer.write(query);
        queryBuffer.writeln('}');

        break;
      }
    }


    if (webConfigBuffer.isEmpty) {
      for (var annotatedElement
          in library.annotatedWith(TypeChecker.fromRuntime(SfwWebConfig))) {
        final String baseUrl =
            annotatedElement.annotation.read('baseUrl').stringValue;
        final bool debug = annotatedElement.annotation.read('debug').boolValue;
        final String contentType=annotatedElement.annotation.read('contentType').stringValue;

        final String responseType =
            annotatedElement.annotation.read('responseType').stringValue;
        final Map<String, String> header ={};
            annotatedElement.annotation.read('header').mapValue.forEach((key,value){
              header["'${key.toStringValue()}'"]="'${value.toStringValue()}'";
            }) ;

        webConfigBuffer.clear();
        webConfigBuffer.writeln('class ${annotatedElement.element.name} {');

        webConfigBuffer.writeln(
            'static final ContentType contentType=ContentType.$contentType;');
        webConfigBuffer.writeln(
            'static final ResponseType responseType=ResponseType.$responseType;');
        webConfigBuffer
            .writeln('static const  Map<String, dynamic> header=$header;');
        webConfigBuffer.writeln('static const  String baseUrl="$baseUrl";');
        webConfigBuffer.writeln('static bool debug=$debug;');

        break;
      }
    }

    for (var annotatedElement
        in library.annotatedWith(_jsonWebCallChecker)) {
      _generateWebCall(
          annotatedElement.element, annotatedElement.annotation, buildStep);
    }

//    if (lastDartFileName == library.element.source.shortName ||
//        "$lastDartFileName.dart" == library.element.source.shortName) {
    if (totalFileCount>-1 &&
        totalFileCount==filesFinished) {
      if (entityGenerator.error == null) {
        _dbBuffer.write(entityGenerator.createStatements);
        _dbBuffer.writeln(
            "String createdAt=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());");
        _dbBuffer.writeln(
            "_batch.execute('CREATE TABLE IF NOT EXISTS sfwMeta (id INTEGER PRIMARY KEY,sfwKey TEXT, sfwValue TEXT,createdAt TEXT,  updatedAt TEXT, type TEXT, fundCode TEXT)');");
        //_dbBuffer.writeln("_batch.rawQuery('INSERT INTO TABLE sfwMeta(sfwKey,sfwValue,createdAt,updatedAt) VALUES ${entityGenerator.tablesMetaData.toString()}',${entityGenerator.tablesMetaDataArgs});");
//        _dbBuffer.writeln('});');
        _dbBuffer.writeln('await _batch.commit(noResult: true);');

        _dbBuffer.writeln('});');
        _dbBuffer.writeln('}');
        _writeSqlFunctions();
        _dbBuffer.writeln('}');
        _mainBuffer.forEach((buffer) {
          _dbBuffer.write(buffer);
        });


        _dbBuffer.writeln("//FUNCTIONS DEFENITION");

        //FUNCTIONS DEFENITION
        if (!entityGenerator.typeDefs
            .contains('typedef IntCallBack = void Function(int value);'))
          _dbBuffer.writeln('typedef IntCallBack = void Function(int value);');
        if (!entityGenerator.typeDefs
            .contains('typedef DbErrorCallBack = void Function(String e);'))
          _dbBuffer
              .writeln('typedef DbErrorCallBack = void Function(String e);');
        entityGenerator.typeDefs.forEach((s) {
          _dbBuffer.writeln(s);
        });
        if(webConfigBuffer.isNotEmpty) {
          _dbBuffer.writeln("//WEBSERVICE");
          _dbBuffer.writeln(webConfigBuffer);
          _dbBuffer.writeln(webQueryBuffer);
          _dbBuffer.writeln("}");
        }
        entityGenerator.typeDefs.clear();
        queryBuffer.writeln('');
        loadAssets(queryBuffer,buildStep);
        queryBuffer.writeln('//CODE GENERATION COMPLETED');
      }
      StringBuffer s = StringBuffer();
      _imports.add("import 'package:intl/intl.dart' show DateFormat;");
      _imports.add("import 'package:sfw_imports/src/web.dart';");
      if(webConfigBuffer.isNotEmpty) {
        _imports.add("import 'package:dio/dio.dart';");
        _imports.add("import 'dart:io' show ContentType,ResponseType;");
      }
      if (entityGenerator.error == null) {
        _imports.forEach((import) {
          s.write(import);
        });
      } else {
        queryBuffer.clear();
        _dbBuffer.clear();
        s.writeln(entityGenerator.error);
      }



      await for (var value in normalizeGeneratorOutput(
          s.toString() + _dbBuffer.toString() + queryBuffer.toString())) {
        assert(value == null || (value.length == value.trim().length));
        values.add(value);
      }
      _mainBuffer.clear();
      _imports.clear();
      _dbBuffer.clear();
      entityGenerator.createStatements.clear();
    }

    return values.join('\n\n');
  }

  _generateWebCall(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! MethodElement) {
      final name = element.name;
      entityGenerator.error =
          'Generator cannot target `$name`. Remove the JsonSerializable annotation from `$name`.';
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }
    DartObject dartObject = _jsonWebCallChecker.firstAnnotationOfExact(element);
    if (dartObject != null) {
      final String responseClassType =
          "${dartObject.getField('responseClassType').toTypeValue()}";
      final String responseGenericType =
          "${dartObject.getField('responseGenericType').toTypeValue()}";
//      final List<int> responseSuccessCodes =
//          dartObject.getField('responseGenericType').toListValue().cast<int>();
//
//      final String url = dartObject.getField('url').toStringValue();
//      final bool useBaseUrl = dartObject.getField('useBaseUrl').toBoolValue();
//      final bool deletePreviousData =
//          dartObject.getField('deletePreviousData').toBoolValue();
//      final String dbTable = dartObject.getField('dbTable').toStringValue();
//      final bool setDataAsNormalParameter =
//          dartObject.getField('setDataAsNormalParameter').toBoolValue();
//      final bool setDataAsNamedParameter =
//          dartObject.getField('setDataAsNamedParameter').toBoolValue();
//      final Map<String, dynamic> header =
//          dartObject.getField('header').toMapValue().cast();
//      final Map<Type, String> dataKeys =
//          dartObject.getField('dataKeys').toMapValue().cast();
//      final String contentType =
//          "${dartObject.getField('contentType').toStringValue()}";
//      final String responseType =
//          "${dartObject.getField('responseType').toStringValue()}";
//      final bool isMultiPart = dartObject.getField('isMultiPart').toBoolValue();

      webQueryBuffer.writeln("static Future<$responseClassType");
      if (dartObject.getField('responseGenericType').toTypeValue() != null)
        webQueryBuffer.write("<$responseGenericType> ");
      webQueryBuffer.write("> ${element.name}(");
      StringBuffer parameters = StringBuffer();
      StringBuffer namedParameters = StringBuffer();
//      if (dataKeys != null &&
//          dataKeys.isNotEmpty &&
//          (setDataAsNormalParameter || setDataAsNamedParameter)) {
//        dataKeys.forEach((key, value) {
//          if (setDataAsNormalParameter) {
//            if (parameters.isNotEmpty) {
//              parameters.write(", ");
//            }
//            parameters.write("$key $value");
//          } else {
//            if (namedParameters.isNotEmpty) {
//              namedParameters.write(", ");
//            }
//            namedParameters.write("$key $value");
//          }
//        });
//      } else {
//        namedParameters.write("Map<String,dynamic> data");
//      }
      webQueryBuffer.write(parameters);
      webQueryBuffer.write(parameters.length > 0 ? ", {" : "");
      webQueryBuffer.write(namedParameters);
      webQueryBuffer.write(parameters.length > 0 ? "}" : "");
      webQueryBuffer.write(" async {");
      webQueryBuffer.write("}");
    }
  }

  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      entityGenerator.error =
          'Generator cannot target `$name`. Remove the JsonSerializable annotation from `$name`.';
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }

    StringBuffer methodBuilder = StringBuffer();

    ///SfwDbQuery
    if ((element as ClassElement).methods.length > 0) {
      final _jsonKeyChecker = TypeChecker.fromRuntime(SfwDbQuery);
      DartObject jsonKeyAnnotation(MethodElement element) =>
          _jsonKeyChecker.firstAnnotationOfExact(element);
      for (MethodElement method in (element as ClassElement).methods) {
        DartObject dartObject = jsonKeyAnnotation(method);
        if (dartObject != null) {
          //DbQuery dbQuery = dartObject as DbQuery;
          if (dartObject.getField('table').toStringValue().trim().isEmpty)
            continue;

          String callbackType =
              dartObject.getField('isList').toBoolValue() ? "List" : "";

          String returnType = dartObject.getField('isList').toBoolValue()
              ? "List<${dartObject.getField('entityType').toTypeValue()}>"
              : "${dartObject.getField('entityType').toTypeValue()}";
          methodBuilder.write('static Future<$returnType> ${method.name}(');

          List<String> queryParams = [
            "distinct",
            "columns",
            "where",
            "whereArgs",
            "groupBy",
            "having",
            "orderBy",
            "offset",
            "limit"
          ];
          List<String> userDefinedParams = [];
          StringBuffer params = StringBuffer();

          method.parameters.forEach((type) {
            methodBuilder.write(", ");
            methodBuilder.write('${type.type} ${type.name}');
            userDefinedParams.add("${type.name}");
          });
          queryParams.forEach((queryParam) {
            if (queryParam == 'limit' && callbackType == '') return;
            params.write(',$queryParam: ');
            if (userDefinedParams.contains(queryParam)) {
              params.write(queryParam);
            } else {
              switch (queryParam) {
                case "distinct":
                  params.write(
                      dartObject.getField('distinct').toBoolValue() ?? false);
                  break;
                case "columns":
                  params.write(dartObject.getField('columns').toListValue());
                  break;
                case "where":
                  params.write(dartObject.getField('where').toStringValue() ==
                          null
                      ? null
                      : "'${dartObject.getField('where').toStringValue()}'");
                  break;
                case "whereArgs":
                  List<dynamic> list =
                      dartObject.getField('whereArgs').toListValue();
                  params.write(list == null ? null : '[');
                  if (list != null) {
                    int i = 0;
                    for (dynamic c in list) {
                      if (i != 0) params.write(', ');
                      i++;
                      if ((c as DartObject).toIntValue() != null)
                        params.write((c as DartObject).toIntValue());
                      else if ((c as DartObject).toDoubleValue() != null)
                        params.write((c as DartObject).toDoubleValue());
                      else if ((c as DartObject).toStringValue() != null)
                        params.write('"${(c as DartObject).toStringValue()}"');
                      else
                        params.write('null');

//                      switch((c as DartObject).runtimeType) {
//                        case int:params.write(c as int);
//                        break;
//                        case String:params.write(c as String);
//                        break;
//                        case double:params.write(c as double);
//                        break;
//                        default:params.write('"${(c as DartObject).toStringValue()}"');
//                      }
                    }
                    params.write(']');
                  }
                  break;
                case "groupBy":
                  params.write(dartObject.getField('groupBy').toStringValue() ==
                          null
                      ? null
                      : "'${dartObject.getField('groupBy').toStringValue()}'");
                  break;
                case "having":
                  params.write(dartObject.getField('having').toStringValue() ==
                          null
                      ? null
                      : "'${dartObject.getField('having').toStringValue()}'");
                  break;
                case "orderBy":
                  params.write(dartObject.getField('orderBy').toStringValue() ==
                          null
                      ? null
                      : "'${dartObject.getField('orderBy').toStringValue()}'");
                  break;
                case "offset":
                  params.write(dartObject.getField('offset').toIntValue());
                  break;
                case "limit":
                  params.write(dartObject.getField('limit').toIntValue());
              }
            }
          });

          methodBuilder.write(') async { ');
          methodBuilder.writeln(' return await ');

//          String tableToUpper =
//              '${dartObject.getField('table').toStringValue()[0].toUpperCase()}${dartObject.getField('table').toStringValue().substring(1)}';
          String call = "";
          if (dartObject.getField('isList').toBoolValue()) {
            call +=
                '${dartObject.getField('entityType').toTypeValue()}SFW.getAll';
          } else {
            call +=
                '${dartObject.getField('entityType').toTypeValue()}SFW.getSingle';
          }

//          call+='From${tableToUpper}Table(callback${params.toString()});';
          call +=
              '("${dartObject.getField('table').toStringValue()}"${params.toString()});';

          methodBuilder.write(call);
          methodBuilder.writeln('');
          // methodBuilder.writeln('return $call');
          methodBuilder.writeln('}');
          methodBuilder.writeln('');
        }
      }
    }

    String dbName = annotation.read('dbName').stringValue;
    int dbVersion = annotation.read('version').intValue;
    //final _builder = StringBuffer();

    // _dbBuffer.writeln("import 'package:path_provider/path_provider.dart';");
    _dbBuffer.writeln("import 'package:sqflite/sqflite.dart';");
    _dbBuffer.writeln("import 'package:path/path.dart';");
//    _dbBuffer.writeln("import 'dart:io';");
    _dbBuffer.writeln("import 'dart:convert' as JSON;");
    _dbBuffer.writeln("import 'dart:core';");
    _dbBuffer.writeln("import 'dart:ui' show Color,FontWeight,TextStyle,FontStyle,TextDecoration;");
    _dbBuffer.writeln("import 'package:flutter/material.dart' show VoidCallback,BuildContext,TextSpan,RichText,DefaultTextStyle;");
    _imports.forEach((import) {
      _dbBuffer.writeln(import);
    });

    //DATABASE
    _dbBuffer.writeln('class DBProvider {');
    _dbBuffer.writeln("static Database _db;");
    _dbBuffer.writeln("static DBProvider _provider;");
    _dbBuffer
        .writeln("static DBProvider getInstance({VoidCallback callback}){");
    _dbBuffer.writeln(
        "if (_provider == null) _provider = DBProvider(callback: callback);");
    _dbBuffer.writeln("if(callback!=null && _db!=null)");
    _dbBuffer.writeln("callback();");
    _dbBuffer.writeln("return _provider;");
    _dbBuffer.writeln("}");
    _dbBuffer.writeln("DBProvider({VoidCallback callback}) {");
    _dbBuffer.writeln("if(callback!=null)");
    _dbBuffer.writeln(" _initDataBase().then((value) {");
    _dbBuffer.writeln("callback();");
    _dbBuffer.writeln("});");
    _dbBuffer.writeln("else");
    _dbBuffer.writeln("_initDataBase();");
    _dbBuffer.writeln("}");
    _dbBuffer.writeln("_initDataBase() async {");
    _dbBuffer.writeln("if (_db == null) _db = await _initDB();");
    _dbBuffer.writeln("}");
    _dbBuffer.writeln("_initDB() async {");
    _dbBuffer.writeln("String dbFolder = await getDatabasesPath();");
    if (!dbName.toLowerCase().endsWith(".db")) dbName += ".db";
    _dbBuffer.writeln("String path = join(dbFolder,'$dbName');");
    _dbBuffer.writeln(
        "return await openDatabase(path, version: $dbVersion, onOpen: (db) {},");
    _dbBuffer.writeln("onCreate: (Database db, int version) async {");
    _dbBuffer.writeln("Batch _batch=db.batch();");
//    _dbBuffer.writeln("await db.transaction((transaction) async  {");

    return methodBuilder.toString();
  }

  void _writeSqlFunctions() {
    _dbBuffer.writeln();
    _dbBuffer.writeln('Batch getBatch() => _db.batch();');
    _dbBuffer.writeln(
        'Future<int> rawDelete(String sql, [List<dynamic> arguments]) =>');
    _dbBuffer.writeln('_db.rawDelete(sql,arguments);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<int> delete(String table, {String where, List<dynamic> whereArgs}) =>');
    _dbBuffer.writeln('_db.delete(table,where:where,whereArgs:whereArgs);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<void> execute(String sql, [List<dynamic> arguments]) => ');
    _dbBuffer.writeln('_db.execute(sql,arguments);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<int> rawInsert(String sql, [List<dynamic> arguments]) => ');
    _dbBuffer.writeln('_db.rawInsert(sql,arguments);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<int> insert(String table, Map<String, dynamic> values,');
    _dbBuffer.write(
        '{String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) => ');
    _dbBuffer.writeln(
        '_db.insert(table,values,nullColumnHack:nullColumnHack,conflictAlgorithm:conflictAlgorithm);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<List<Map<String, dynamic>>> query(String table,{bool distinct = false,List<String> columns,');
    _dbBuffer.write(
        ' String where, List<dynamic> whereArgs, String groupBy, String having,');
    _dbBuffer.write(' String orderBy, int limit, int offset}) => ');
    _dbBuffer.writeln(
        ' _db.query(table, distinct:distinct ?? false, columns:columns, where:where, whereArgs:whereArgs,');
    _dbBuffer.write(
        ' groupBy:groupBy, having:having, orderBy:orderBy, limit:limit, offset:offset);');
    _dbBuffer.writeln();
    _dbBuffer.write(
        ' Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic> arguments]) => ');
    _dbBuffer.writeln('_db.rawQuery(sql,arguments);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<int> rawUpdate(String sql, [List<dynamic> arguments]) => ');
    _dbBuffer.writeln('_db.rawUpdate(sql,arguments);');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        'Future<int> update(String table, Map<String, dynamic> values,');
    _dbBuffer.write(
        '{String where, List<dynamic> whereArgs, ConflictAlgorithm conflictAlgorithm}) => ');
    _dbBuffer.writeln();
    _dbBuffer.writeln(
        '_db.update(table,values,where:where,whereArgs:whereArgs,conflictAlgorithm:conflictAlgorithm);');
    _dbBuffer.writeln();
  }

  void loadAssets(StringBuffer s,BuildStep buildStep) async {
    s.writeln("String ddddd='${buildStep.inputId.package} ${buildStep.inputId.path}';");
    String str= await buildStep.readAsString(AssetId(buildStep.inputId.package, "lib/test.txt"));
    s.writeln("String ssss='$str';");
    str= await buildStep.readAsString(AssetId("sfw_generator", "lib/test.txt"));
    s.writeln("String ssss='$str';");
//    DefaultAssetBundle bundle=DefaultAssetBundle.of(context);
//    s.writeln(await rootBundle.loadString("assets/sfw_html.dart"));
  }
}
