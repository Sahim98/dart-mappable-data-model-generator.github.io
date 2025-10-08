import 'mappable_options.dart';

class ModelConfig {
  final String className;
  final Map<String, dynamic> jsonMap; // store parsed JSON
  final MappableOptions options;
  final bool nullSafety; // new toggle for null safety

  ModelConfig({
    required this.className,
    required this.jsonMap,
    required this.options,
    required this.nullSafety,
  });

  factory ModelConfig.initial() => ModelConfig(
        className: 'MyModel',
        jsonMap: {},
        options: MappableOptions.initial(),
        nullSafety: true,
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
