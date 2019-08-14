import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:sfw_imports/sfw_imports.dart' ;
import 'package:source_gen/source_gen.dart';

final _jsonKeyChecker = const TypeChecker.fromRuntime(SfwEntity);
final _dbNameChecker = const TypeChecker.fromRuntime(SfwDbField);
final _dbExcludeChecker = const TypeChecker.fromRuntime(SfwDbExclude);
DartObject jsonKeyAnnotation(FieldElement element) =>
    _jsonKeyChecker.firstAnnotationOfExact(element) ??
        (element.getter == null
            ? null
            : _jsonKeyChecker.firstAnnotationOfExact(element.getter));

DartObject annotationForDbName(FieldElement element) =>
    _dbNameChecker.firstAnnotationOfExact(element) ??
        (element.getter == null
            ? null
            : _dbNameChecker.firstAnnotationOfExact(element.getter));
DartObject annotationForDbExclude(FieldElement element) =>
    _dbExcludeChecker.firstAnnotationOfExact(element) ??
        (element.getter == null
            ? null
            : _dbExcludeChecker.firstAnnotationOfExact(element.getter));

bool hasJsonKeyAnnotation(FieldElement element) =>
    jsonKeyAnnotation(element) != null;

class ConstructorData {
  final String content;
  final Set<String> fieldsToSet;
  final Set<String> usedCtorParamsAndFields;

  ConstructorData(
      this.content, this.fieldsToSet, this.usedCtorParamsAndFields);
}
class Reflection {
  String genericClassArguments(ClassElement element, bool withConstraints) {
    if (withConstraints == null || element.typeParameters.isEmpty) {
      return '';
    }
    final values = element.typeParameters
        .map((t) => withConstraints ? t.toString() : t.name)
        .join(', ');
    return '<$values>';
  }



  ConstructorData writeConstructorInvocation(
      ClassElement classElement,
      Iterable<String> availableConstructorParameters,
      Iterable<String> writableFields,
      Map<String, String> unavailableReasons,
      String deserializeForField(String paramOrFieldName,
          {ParameterElement ctorParam})) {
    final className = classElement.name;

    final ctor = classElement.unnamedConstructor;
    if (ctor == null) {
      // TODO(kevmoo): support using another ctor - dart-lang/json_serializable#50
      throw InvalidGenerationSourceError(
          'The class `$className` has no default constructor.',
          element: classElement);
    }

    final usedCtorParamsAndFields = <String>{};
    final constructorArguments = <ParameterElement>[];
    final namedConstructorArguments = <ParameterElement>[];

    for (final arg in ctor.parameters) {
      if (!availableConstructorParameters.contains(arg.name)) {
        if (arg.isNotOptional) {
          var msg = 'Cannot populate the required constructor '
              'argument: ${arg.name}.';

          final additionalInfo = unavailableReasons[arg.name];

          if (additionalInfo != null) {
            msg = '$msg $additionalInfo';
          }

          throw InvalidGenerationSourceError(msg, element: ctor);
        }

        continue;
      }

      // TODO: validate that the types match!
      if (arg.isNamed) {
        namedConstructorArguments.add(arg);
      } else {
        constructorArguments.add(arg);
      }
      usedCtorParamsAndFields.add(arg.name);
    }

    // fields that aren't already set by the constructor and that aren't final
    final remainingFieldsForInvocationBody =
    writableFields.toSet().difference(usedCtorParamsAndFields);

    final buffer = StringBuffer();
    buffer.write('$className${genericClassArguments(classElement, false)}(');
    if (constructorArguments.isNotEmpty) {
      buffer.writeln();
      buffer.writeAll(constructorArguments.map((paramElement) {
        final content =
        deserializeForField(paramElement.name, ctorParam: paramElement);
        return '      $content';
      }), ',\n');
      if (namedConstructorArguments.isNotEmpty) {
        buffer.write(',');
      }
    }
    if (namedConstructorArguments.isNotEmpty) {
      buffer.writeln();
      buffer.writeAll(namedConstructorArguments.map((paramElement) {
        final value =
        deserializeForField(paramElement.name, ctorParam: paramElement);
        return '      ${paramElement.name}: $value';
      }), ',\n');
    }

    buffer.write(')');

    usedCtorParamsAndFields.addAll(remainingFieldsForInvocationBody);

    return ConstructorData(buffer.toString(), remainingFieldsForInvocationBody,
        usedCtorParamsAndFields);
  }
}

class FieldSet implements Comparable<FieldSet> {
  final FieldElement field;
  final FieldElement sortField;

  FieldSet._(this.field, this.sortField)
      : assert(field.name == sortField.name);

  factory FieldSet(FieldElement classField, FieldElement superField) {
    // At least one of these will != null, perhaps both.
    final fields = [classField, superField].where((fe) => fe != null).toList();

    // Prefer the class field over the inherited field when sorting.
    final sortField = fields.first;

    // Prefer the field that's annotated with `JsonKey`, if any.
    // If not, use the class field.
    final fieldHasJsonKey =
    fields.firstWhere(hasJsonKeyAnnotation, orElse: () => fields.first);

    return FieldSet._(fieldHasJsonKey, sortField);
  }

  @override
  int compareTo(FieldSet other) => _sortByLocation(sortField, other.sortField);

  static int _sortByLocation(FieldElement a, FieldElement b) {
    final checkerA = TypeChecker.fromStatic((a.enclosingElement as ClassElement).type);

    if (!checkerA.isExactly(b.enclosingElement)) {
      // in this case, you want to prioritize the enclosingElement that is more
      // "super".

      if (checkerA.isAssignableFrom(b.enclosingElement)) {
        return -1;
      }

      final checkerB = TypeChecker.fromStatic((b.enclosingElement as ClassElement).type);

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