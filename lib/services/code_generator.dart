import 'package:recase/recase.dart';
import 'package:dart_style/dart_style.dart';
import '../models/mappable_options.dart';

final _formatter = DartFormatter();

/// Generate Dart classes recursively from JSON map
String generateClassFromJson(
  String className,
  Map<String, dynamic> jsonMap,
  MappableOptions options,
) {
  final buffer = StringBuffer();
  final generatedClasses = <String>{};

  String _makeNullable(String type) {
    if (type.endsWith('?')) return type;
    return '$type?';
  }

  void _generate(String className, Map<String, dynamic> json) {
    final fields = <String, String>{}; // fieldName -> type
    final nested = <String, Map<String, dynamic>>{};

    // detect field types
    json.forEach((key, value) {
      String fieldType;

      if (value == null) {
        fieldType = 'String?';
      } else if (value is Map<String, dynamic>) {
        final nestedName = ReCase(key).pascalCase;
        nested[nestedName] = value;
        fieldType = nestedName;
      } else if (value is List) {
        if (value.isEmpty) {
          fieldType = 'List<dynamic>';
        } else if (value.first is Map<String, dynamic>) {
          final nestedName = ReCase(key).pascalCase;
          nested[nestedName] = value.first;
          fieldType = 'List<$nestedName>';
        } else {
          final itemType = _inferType(value.first);
          fieldType = 'List<$itemType>';
        }
      } else {
        fieldType = _inferType(value);
      }

      // Make nullable if ignoreNull is false
      fields[key] = options.ignoreNull ? fieldType : _makeNullable(fieldType);
    });

    // generate current class first
    final annotation = _buildMappableAnnotation(options);
    buffer.writeln('// GENERATED CLASS: $className');
    buffer.writeln(annotation);
    buffer.writeln('class $className with ${className}Mappable {');

    fields.forEach((name, type) {
      buffer.writeln('  final $type $name;');
    });

    // constructor
    buffer.writeln('');
    buffer.writeln('  const $className({');
    fields.forEach((name, type) {
      final requiredField = type.endsWith('?') ? '' : 'required ';
      buffer.writeln('    $requiredField$name,');
    });
    buffer.writeln('  });\n}');
    buffer.writeln('');

    // generate nested classes after
    nested.forEach((nestedName, nestedJson) {
      if (!generatedClasses.contains(nestedName)) {
        generatedClasses.add(nestedName);
        _generate(nestedName, nestedJson);
      }
    });
  }

  _generate(ReCase(className).pascalCase, jsonMap);

  try {
    return _formatter.format(buffer.toString());
  } catch (_) {
    return buffer.toString();
  }
}

/// Build Mappable annotation
String _buildMappableAnnotation(MappableOptions o) {
  final params = <String>[];
  if (o.ignoreNull) params.add('ignoreNull: true');
  if (o.caseStyle.isNotEmpty) params.add('caseStyle: CaseStyle.${o.caseStyle}');
  if (o.generateMethods.isNotEmpty) {
    final methods = o.generateMethods
        .map((m) => 'GenerateMethods.$m')
        .join(' | ');
    params.add('generateMethods: $methods');
  }
  if (params.isEmpty) return '@MappableClass()';
  return '@MappableClass(${params.join(', ')})';
}

/// Infer Dart type for primitives
String _inferType(dynamic value) {
  if (value == null) return 'String?';
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) return 'String';
  return 'dynamic';
}



/// Converts annotated Mappable model classes into
/// Entity + Model classes where:
/// - Entity: plain class with entity
/// - Model: extends corresponding Entity
Map<String, String> convertModelToEntity(String modelCode) {
  final entityBuffer = StringBuffer();

  final classRegex = RegExp(
    r'@MappableClass[^\n]*\n\s*class\s+(\w+)\s+(?:extends\s+\w+\s+)?with\s+(\w+)',
    multiLine: true,
  );

  final matches = classRegex.allMatches(modelCode);
  final formatter = DartFormatter();

  for (final match in matches) {
    final className = match.group(1)!;
    final startIndex = match.start;

    // find where the class body ends by brace matching
    final braceStart = modelCode.indexOf('{', startIndex);
    int braceCount = 1;
    int endIndex = braceStart + 1;
    while (endIndex < modelCode.length && braceCount > 0) {
      if (modelCode[endIndex] == '{') braceCount++;
      if (modelCode[endIndex] == '}') braceCount--;
      endIndex++;
    }

    final classContent = modelCode.substring(startIndex, endIndex);

    // Generate clean Entity version
    final entityClass = classContent
        .replaceFirst(RegExp(r'@MappableClass[^\n]*\n'), '')
        .replaceFirst(RegExp(r'class\s+$className\s+[^\{]*'), 'class ${className}Entity ')
        .replaceAll(RegExp(r'with\s+\w+'), '') // remove with mixins
        .trim();

    entityBuffer.writeln('// ENTITY CLASS GENERATED FROM $className');
    entityBuffer.writeln(entityClass);
    entityBuffer.writeln('\n');
  }

  // Now generate models extending their Entity versions
  final modelModified = modelCode.replaceAllMapped(classRegex, (match) {
    final className = match.group(1)!;
    final mixin = match.group(2)!;
    return '@MappableClass()\nclass $className extends ${className}Entity with $mixin';
  });

  try {
    return {
      'entity': formatter.format(entityBuffer.toString()),
      'model': formatter.format(modelModified),
    };
  } catch (_) {
    // fallback unformatted
    return {
      'entity': entityBuffer.toString(),
      'model': modelModified,
    };
  }
}

