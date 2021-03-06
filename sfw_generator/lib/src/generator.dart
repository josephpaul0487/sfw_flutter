import 'dart:async';

import 'package:analyzer/dart/constant/value.dart' show DartObject;
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:sfw_imports/sfw_imports.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart';
import 'entity.dart' as entityGenerator;
import 'xmldocs.dart';

int totalElements = 0;
List<StringBuffer> _mainBuffer = [];
Set<String> _imports = {};
StringBuffer _dbBuffer = StringBuffer();
StringBuffer queryBuffer = StringBuffer();
StringBuffer webQueryBuffer = StringBuffer();
StringBuffer webConfigBuffer = StringBuffer();
int filesFinished = 0;
int totalFileCount = -1;
String dbName;

int dbVersion;
String dbClassImport;
String dbOriginalClassName;

//flutter packages pub run build_runner clean
//flutter packages pub run build_runner build
//flutter packages pub run build_runner build --delete-conflicting-outputs



class DbGenerator extends Generator {
  final _jsonWebCallChecker = TypeChecker.fromRuntime(SfwWebCall);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    ++filesFinished;
    log.warning(
        "FILE :  ${library.element.source.shortName}  finishedFileCount = $filesFinished");
    await XmlDocs.isStyleAsset(library, buildStep);
    await XmlDocs.isStringAsset(library, buildStep);
//    if(await XmlDocs.isStyleAsset(library, buildStep) || await XmlDocs.isStringAsset(library, buildStep))
//      return "";
    await loadAssets(library, buildStep);


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

        totalFileCount =
            annotatedElement.annotation.read('totalFileCount').intValue;

        queryBuffer.clear();
        queryBuffer.writeln('class ${annotatedElement.element.name} {');
        queryBuffer.write(query);
        queryBuffer.writeln('}');
        dbOriginalClassName = annotatedElement.element.name;
        dbClassImport =
            "import '${library.element.source.uri}' as SfwConfigDb show ${annotatedElement.element.name};";
        break;
      }
    }

    if (webConfigBuffer.isEmpty) {
      for (var annotatedElement
          in library.annotatedWith(TypeChecker.fromRuntime(SfwWebConfig))) {
        final String baseUrl =
            annotatedElement.annotation.read('baseUrl').stringValue;
        final bool debug = annotatedElement.annotation.read('debug').boolValue;
        final String contentType =
            annotatedElement.annotation.read('contentType').stringValue;

        final String responseType =
            annotatedElement.annotation.read('responseType').stringValue;
        final Map<String, String> header = {};
        var entries =
            annotatedElement.annotation.read('header').mapValue.entries;

        for (var entry in entries) {
          header["'${entry.key.toStringValue()}'"] =
              "'${entry.value.toStringValue()}'";
        }

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

    for (var annotatedElement in library.annotatedWith(_jsonWebCallChecker)) {
      _generateWebCall(
          annotatedElement.element, annotatedElement.annotation, buildStep);
    }
    if (totalFileCount > -1 && totalFileCount == filesFinished) {
      if (entityGenerator.error == null) {
        //_dbBuffer.write(entityGenerator.createStatements);
        entityGenerator.createStatements.writeln(
            "String createdAt=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());");
        entityGenerator.createStatements.writeln(
            "_batch.execute('CREATE TABLE IF NOT EXISTS sfwMeta (id INTEGER PRIMARY KEY,sfwKey TEXT, sfwValue TEXT,createdAt TEXT,  updatedAt TEXT, type TEXT, fundCode TEXT)');");
        entityGenerator.createStatements.writeln("_batch.delete('sfwMeta');");
        for (var map in entityGenerator.tablesMetaData) {
          entityGenerator.createStatements.writeln(
              "_batch.insert('sfwMeta', {$map,'createdAt':'\$createdAt','updatedAt':'\$createdAt'});");
        }


        await createDb(
            _dbBuffer,
            buildStep,
            dbVersion,
            dbName,
            entityGenerator.createStatements.toString(),
            entityGenerator.tablesMetaData);

        for (var buffer in _mainBuffer) {
          _dbBuffer.write(buffer);
        }

        _dbBuffer.writeln("//FUNCTIONS DEFINITION");

        //FUNCTIONS DEFINITION
        if (!entityGenerator.typeDefs
            .contains('typedef IntCallBack = void Function(int value);'))
          _dbBuffer.writeln('typedef IntCallBack = void Function(int value);');
        if (!entityGenerator.typeDefs
            .contains('typedef DbErrorCallBack = void Function(String e);'))
          _dbBuffer
              .writeln('typedef DbErrorCallBack = void Function(String e);');
        for (var s in entityGenerator.typeDefs) {
          _dbBuffer.writeln(s);
        }
        if (webConfigBuffer.isNotEmpty) {
          _dbBuffer.writeln("//WEBSERVICE");
          _dbBuffer.writeln(webConfigBuffer);
          _dbBuffer.writeln(webQueryBuffer);
          _dbBuffer.writeln("}");
        }
        entityGenerator.typeDefs.clear();
        queryBuffer.writeln('');
        //await loadAssets(queryBuffer, buildStep);
        //await XmlDocs.build(queryBuffer, buildStep);
        queryBuffer.writeln('//CODE GENERATION COMPLETED');
      }
      StringBuffer s = StringBuffer();
      _imports.add("import 'package:intl/intl.dart' show DateFormat;");
      _imports.add("import 'package:sfw_imports/src/web.dart';");
      _imports.add("import 'package:permission_handler/permission_handler.dart';");
      if (webConfigBuffer.isNotEmpty) {
        _imports.add("import 'package:dio/dio.dart';");
        _imports.add("import 'dart:io' show ContentType,ResponseType;");
      }
      if (dbClassImport != null) _imports.add(dbClassImport);
      if (entityGenerator.error == null) {
        for (var import in _imports) {
          s.write(import);
        }
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
          int paramCount = 0;
          for (var type in method.parameters) {
            //Write all parameters to the generated method
            if (paramCount > 0) methodBuilder.write(", ");
            ++paramCount;
            methodBuilder.write('${type.type} ${type.name}');
            userDefinedParams.add("${type.name}");
          }
          for (var queryParam in queryParams) {
            if (queryParam == 'limit' && callbackType == '') continue;
            params.write(',$queryParam: ');
            if (userDefinedParams.contains(queryParam)) {
              //check is user specified the query key
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
          }

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

    dbName = annotation.read('dbName').stringValue;
    dbVersion = annotation.read('version').intValue;
    if (!dbName.toLowerCase().endsWith(".db")) dbName += ".db";
    //final _builder = StringBuffer();

    // _dbBuffer.writeln("import 'package:path_provider/path_provider.dart';");
    _dbBuffer.writeln("import 'package:sqflite/sqflite.dart';");
    _dbBuffer.writeln("import 'package:path/path.dart';");
//    _dbBuffer.writeln("import 'dart:io';");
    _dbBuffer.writeln("import 'dart:convert' as JSON;");
    _dbBuffer.writeln("import 'dart:core';");
    // _dbBuffer.writeln("import 'package:intl/intl.dart';");
    _dbBuffer.writeln("import 'package:fluttertoast/fluttertoast.dart';");
    _dbBuffer.writeln("import 'package:flutter/cupertino.dart';");
    // _dbBuffer.writeln("import 'dart:ui' show Color,FontWeight,TextStyle,FontStyle,TextDecoration;");
    _dbBuffer.writeln(
        "import 'package:flutter_screenutil/flutter_screenutil.dart';");
    _dbBuffer.writeln(
        "import 'package:flutter/material.dart';"); // show VoidCallback,BuildContext,TextSpan,RichText,DefaultTextStyle,StatefulWidget,State,Colors;");
    for (var import in _imports) {
      _dbBuffer.writeln(import);
    }
    return methodBuilder.toString();
  }

  Future loadAssets(LibraryReader library, BuildStep buildStep) async {
    if (library.element.source.shortName == "animations.dart") {
      buildStep.writeAsString(AssetId(buildStep.inputId.package,
          buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
          await readAsset(
              AssetId("sfw_generator", "lib/src/assets/animation_helper.d"),
              buildStep));
    } else if (library.element.source.shortName == "sfw.dart") {
      buildStep.writeAsString(AssetId(buildStep.inputId.package,
          buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
          await readAsset(
              AssetId("sfw_generator", "lib/src/assets/app_helper.d"),
              buildStep));
    } else if (library.element.source.shortName == "ui.dart") {
      buildStep.writeAsString(AssetId(buildStep.inputId.package,
          buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
          await readAsset(
              AssetId("sfw_generator", "lib/src/assets/sfw_ui.d"), buildStep));
    } else if (library.element.source.shortName == "ui_helper.dart") {

      buildStep.writeAsString(AssetId(buildStep.inputId.package,
          buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
          await readAsset(
              AssetId("sfw_generator", "lib/src/assets/ui_helper.d"),
              buildStep) );
    }
  }

  Future createDb(StringBuffer s, BuildStep buildStep, int dbVersion,
      String dbName, String dbTransaction, List<String> tablesMetaData) async {
    String db = await readAsset(
        AssetId("sfw_generator", "lib/src/assets/db.d"), buildStep);

   List<String> meta=[];
   for(var c in tablesMetaData) {
     meta.add("'$c'");
   }
    db = db
        .replaceFirst("dbVersion", "$dbVersion")
        .replaceFirst("dbName", dbName)
        .replaceFirst("dbTransaction", dbTransaction)
        .replaceFirst("TABLE_DETAILS", '$meta')
        .replaceAll("SFW_CONFIG_CLASS", dbOriginalClassName);

    s.writeln(db);
  }

  Future<String> readAsset(AssetId assetId, BuildStep buildStep) async {
    try {
      return await buildStep.readAsString(assetId);
    } catch (e) {
      return e.toString();
    }
  }
}
