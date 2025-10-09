import 'package:quick_parse/utils/enum/conversion_mode_enum.dart';

import 'mappable_options.dart';

class ModelConfig {
  final String className;
  final Map<String, dynamic> jsonMap; // store parsed JSON
  final MappableOptions options;
  final bool nullSafety; // new toggle for null safety
 //  final ConversionMode mode; // new field
 // final String rawModelInput; // used when converting model -> entity


  ModelConfig({
    required this.className,
    required this.jsonMap,
    required this.options,
    required this.nullSafety,
  // required this.mode,
   // required this.rawModelInput,
  });

  factory ModelConfig.initial() => ModelConfig(
        className: 'MyModel',
        jsonMap: {},
        options: MappableOptions.initial(),
        nullSafety: true,
       // mode: ConversionMode.jsonToModel,
       // rawModelInput: 'Enter your Dart class here...',
      );

  ModelConfig copyWith({
    String? className,
    Map<String, dynamic>? jsonMap,
    MappableOptions? options,
    bool? nullSafety,
  }) {
    return ModelConfig(
      className: className ?? this.className,
      jsonMap: jsonMap ?? this.jsonMap,
      options: options ?? this.options,
      nullSafety: nullSafety ?? this.nullSafety,
    );
  }
}
