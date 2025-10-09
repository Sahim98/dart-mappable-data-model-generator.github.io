import 'dart:developer';

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

  String makeNullable(String type) {
    if (type.endsWith('?')) return type;
    return '$type?';
  }

  void generate(String className, Map<String, dynamic> json) {
    final fields = <String, String>{}; // fieldName -> type
    final nested = <String, Map<String, dynamic>>{};

    // detect field types
    json.forEach((key, value) {
      String fieldType;

      if (value == null) {
        fieldType = 'dynamic';
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
      fields[key] = options.ignoreNull ? fieldType : makeNullable(fieldType);
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
        generate(nestedName, nestedJson);
      }
    });
  }

  generate(ReCase(className).pascalCase, jsonMap);

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
        .map((m) => 'GenerateMethods.${_capitalize(m)}')
        .join(' | ');
    params.add('generateMethods: $methods');
  }
  if (params.isEmpty) return '@MappableClass()';
  return '@MappableClass(${params.join(', ')})';
}

/// Capitalize first letter of a string
String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

/// Infer Dart type for primitives
String _inferType(dynamic value) {
  if (value == null) return 'dynamic';
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) return 'String';
  return 'dynamic';
}

/// Check if a type is a primary type (String, int, double, num)
bool _isPrimaryType(String type) {
  // Remove nullable marker, whitespace, and generics
  final baseType = type.replaceAll('?', '').trim().split('<')[0];
  return baseType == 'String' ||
      baseType == 'int' ||
      baseType == 'double' ||
      baseType == 'num' ||
      baseType == 'bool';
}

/// Extract fields from class content
Map<String, String> _extractFields(String classContent) {
  final fields = <String, String>{};
  // Match: final Type fieldName;
  final fieldRegex = RegExp(r'final\s+([\w<>?,\s]+)\s+(\w+)\s*;');
  final matches = fieldRegex.allMatches(classContent);

  for (final match in matches) {
    final type = match.group(1)!.trim();
    final name = match.group(2)!;
    fields[name] = type;
  }

  return fields;
}

Map<String, String> convertModelToEntity(String modelCode) {
  log("modelCode: $modelCode");
  // Handle empty or whitespace-only input
  if (modelCode.trim().isEmpty) {
    return {'entity': '', 'model': ''};
  }

  final entityBuffer = StringBuffer();
  final modelBuffer = StringBuffer();
  final formatter = DartFormatter();

  // Match @MappableClass and class declaration
  final classRegex = RegExp(
    r'@MappableClass[^\n]*\n\s*class\s+(\w+)(?:\s+extends\s+\w+)?(?:\s+with\s+(\w+))?',
    multiLine: true,
  );

  final matches = classRegex.allMatches(modelCode);

  for (final match in matches) {
    final className = match.group(1)!;
    final mixin = match.group(2);
    final startIndex = match.start;

    // Find class body braces
    final braceStart = modelCode.indexOf('{', startIndex);
    int braceCount = 1;
    int endIndex = braceStart + 1;
    while (endIndex < modelCode.length && braceCount > 0) {
      if (modelCode[endIndex] == '{') braceCount++;
      if (modelCode[endIndex] == '}') braceCount--;
      endIndex++;
    }

    final classContent = modelCode.substring(startIndex, endIndex);

    // Extract fields to determine which are primary types
    final fields = _extractFields(classContent);

    // Construct Entity name
    final entityName = className.endsWith('Entity')
        ? className
        : '${className}Entity';

    // Create Entity class version (keep all fields)
    var entityClass = classContent
        // Remove annotation
        .replaceFirst(RegExp(r'@MappableClass[^\n]*\n'), '')
        // Replace entire class declaration line properly
        .replaceFirstMapped(
          RegExp(r'class\s+' + className + r'(?:\s+[^{]*)?\{'),
          (m) => 'class $entityName {',
        )
        // Remove with clauses
        .replaceAll(RegExp(r'with\s+\w+'), '')
        // Fix constructor name to match entity name
        .replaceAllMapped(
          RegExp(r'const\s+' + className + r'\('),
          (m) => 'const $entityName(',
        )
        .trim();

    entityBuffer.writeln('// ENTITY CLASS GENERATED FROM $className');
    entityBuffer.writeln(entityClass);
    entityBuffer.writeln('\n');

    // Create Model class that extends Entity
    final mixinPart = mixin != null ? ' with $mixin' : '';

    // Start building model class
    modelBuffer.writeln('@MappableClass()');
    modelBuffer.writeln('class $className extends $entityName$mixinPart {');

    // Add only non-primary type fields
    fields.forEach((name, type) {
      if (!_isPrimaryType(type)) {
        modelBuffer.writeln('  final $type $name;');
      }
    });

    // Add constructor
    modelBuffer.writeln('');
    modelBuffer.writeln('  const $className({');

    // Add constructor parameters
    fields.forEach((name, type) {
      if (_isPrimaryType(type)) {
        // Use super. for primary types (no 'required' prefix needed)
        modelBuffer.writeln('    super.$name,');
      } else {
        // Use this. for non-primary types (with 'required' if not nullable)
        final requiredPart = type.endsWith('?') ? '' : 'required ';
        modelBuffer.writeln('    ${requiredPart}this.$name,');
      }
    });

    modelBuffer.writeln('  });');
    modelBuffer.writeln('}');
    modelBuffer.writeln('');
  }

  try {
    return {
      'entity': formatter.format(entityBuffer.toString()),
      'model': formatter.format(modelBuffer.toString()),
    };
  } catch (e) {
    log('Formatting error: $e');
    return {'entity': entityBuffer.toString(), 'model': modelBuffer.toString()};
  }
}
