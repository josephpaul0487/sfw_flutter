import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:sfw_imports/sfw_imports.dart';
import 'package:source_gen/source_gen.dart';

int totalElements = 0;
LibraryReader _library;

class DbGenerator extends GeneratorForAnnotation<SfwDbConfig> {
  int i = 0;


  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    _library = library;

    return super.generate(library, buildStep);
  }

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }
    final _builder = StringBuffer();

    _builder.writeln("import 'package:path_provider/path_provider.dart'");
    _builder.writeln("import 'package:sqflite/sqflite.dart'");
    _builder.writeln("import 'dart:io'");
    _builder.writeln("import 'dart:convert'");


    Iterable<AnnotatedElement> queries = _library.annotatedWith(
        TypeChecker.fromRuntime(SfwDbQuery));
    totalElements = queries.length;
    queries.forEach((e) {
      final methodElement = element as MethodElement;
      final helper = _GeneratorHelper();
    });
    return _builder.toString();
  }
}



class _GeneratorHelper {
   void _generate(
      MethodElement element, int finishedElementsCount,StringBuffer buffer) sync* {


  }
}

final _jsonKeyChecker = const TypeChecker.fromRuntime(SfwEntity);

DartObject jsonKeyAnnotation(FieldElement element) =>
    _jsonKeyChecker.firstAnnotationOfExact(element) ??
    (element.getter == null
        ? null
        : _jsonKeyChecker.firstAnnotationOfExact(element.getter));

bool hasJsonKeyAnnotation(FieldElement element) =>
    jsonKeyAnnotation(element) != null;
const _dartCoreObjectChecker = TypeChecker.fromRuntime(Object);
