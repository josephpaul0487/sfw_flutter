import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:analyzer/dart/constant/value.dart';

import 'package:sfw_imports/sfw_imports.dart';

import 'package:analyzer/src/dart/resolver/inheritance_manager.dart'
    show InheritanceManager; // ignore: deprecated_member_use

int totalElements = 0;
List<StringBuffer> _mainBuffer= [];
Set<String> _imports={};

class DbGenerator extends GeneratorForAnnotation<SfwDbConfig> {


  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) {
    log.warning("dsadsadasda");
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError('Generator cannot target `$name`.',
          todo: 'Remove the JsonSerializable annotation from `$name`.',
          element: element);
    }
    final _builder = StringBuffer();

    _builder.writeln("import 'package:path_provider/path_provider.dart';");
    _builder.writeln("import 'package:sqflite/sqflite.dart';");
    _builder.writeln("import 'dart:io';");
    _builder.writeln("import 'dart:convert';");
    _builder.writeln("import 'dart:core';");
    _imports.forEach((import){
      _builder.writeln(import);
    });

    return _builder.toString();
  }
}

class EntitiesGenerator extends GeneratorForAnnotation<SfwEntity> {
  int i = 0;

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    totalElements = library.annotatedWith(typeChecker).length;
    return super.generate(library, buildStep);
  }

  @override
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
     final _gen=helper._generate(classElement, i);

    i++;

    return _gen;
    // return {"// Hey! Annotation found!  $s"};
  }

  static Iterable<FieldElement> createSortedFieldSet(ClassElement element) {
    // Get all of the fields that need to be assigned
    final elementInstanceFields = Map.fromEntries(element.fields
        .where((e) => !e.isStatic)
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
        .map((e) => _FieldSet(elementInstanceFields[e], inheritedFields[e]))
        .toList();

    // Sort the fields using the `compare` implementation in _FieldSet
    fields.sort();

    return fields.map((fs) => fs.field).toList();
  }
}

class _FieldSet implements Comparable<_FieldSet> {
  final FieldElement field;
  final FieldElement sortField;

  _FieldSet._(this.field, this.sortField)
      : assert(field.name == sortField.name);

  factory _FieldSet(FieldElement classField, FieldElement superField) {
    // At least one of these will != null, perhaps both.
    final fields = [classField, superField].where((fe) => fe != null).toList();

    // Prefer the class field over the inherited field when sorting.
    final sortField = fields.first;

    // Prefer the field that's annotated with `JsonKey`, if any.
    // If not, use the class field.
    final fieldHasJsonKey =
        fields.firstWhere(hasJsonKeyAnnotation, orElse: () => fields.first);

    return _FieldSet._(fieldHasJsonKey, sortField);
  }

  @override
  int compareTo(_FieldSet other) => _sortByLocation(sortField, other.sortField);

  static int _sortByLocation(FieldElement a, FieldElement b) {
    final checkerA = TypeChecker.fromStatic(a.enclosingElement.type);

    if (!checkerA.isExactly(b.enclosingElement)) {
      // in this case, you want to prioritize the enclosingElement that is more
      // "super".

      if (checkerA.isAssignableFrom(b.enclosingElement)) {
        return -1;
      }

      final checkerB = TypeChecker.fromStatic(b.enclosingElement.type);

      if (checkerB.isAssignableFrom(a.enclosingElement)) {
        return 1;
      }
    }

    /// Returns the offset of given field/property in its source file – with a
    /// preference for the getter if it's defined.
    int _offsetFor(FieldElement e) {
      if (e.getter != null && e.getter.nameOffset != e.nameOffset) {
        assert(e.nameOffset == -1);
        return e.getter.nameOffset;
      }
      return e.nameOffset;
    }

    return _offsetFor(a).compareTo(_offsetFor(b));
  }
}

class _GeneratorHelper {
  final _addedMembers = <String>{};

  String _generate(
      ClassElement element, int finishedElementsCount)  {
    assert(_addedMembers.isEmpty);
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
    if (finishedElementsCount == 0) {
      //buffer.writeln("import 'dart:core';");
      _imports.add("import '${element.source.shortName}';");
      //buffer.writeln("import '${element.source.shortName}';");
    }

    //CLASS
    buffer.writeln('class ${element.name}Helper {');

    //TO JSON
    buffer.writeln(
        '    static Map<String, dynamic> toJson(${element.name} model) => <String, dynamic> {');
    StringBuffer fromJson = StringBuffer(
        '    static ${element.name} fromJson(Map<String, dynamic> json) => ${element.name}() ');
    int i = 0;
    accessibleFields.forEach((str, e) {
      if (i != 0) {
        buffer.writeln(",");
//        fromJson.writeln(",");
      }
      i++;
      buffer.write("   '$str': model.$str");
      fromJson.writeln("   ..$str= json['$str'] as ${e.type}");
    });
    buffer.writeln('    };');
    fromJson.write('    ;');

    buffer.writeln(fromJson);

    buffer.writeln('}');
    if ((finishedElementsCount + 1) == totalElements)
      buffer.writeln('//CODE GENERATION COMPLETED');
    _mainBuffer.add(buffer);
    //_addedMembers.add(buffer.toString());
    return buffer.toString();
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
