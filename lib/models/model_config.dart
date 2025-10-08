import 'mappable_options.dart';

class ModelConfig {
  final String className;
  final Map<String, dynamic> jsonMap; // store parsed JSON
  final MappableOptions options;

  ModelConfig({
    required this.className,
    required this.jsonMap,
    required this.options,
  });

  factory ModelConfig.initial() => ModelConfig(
        className: 'MyModel',
        jsonMap: {},
        options: MappableOptions(),
      );

  ModelConfig copyWith({
    String? className,
    Map<String, dynamic>? jsonMap,
    MappableOptions? options,
  }) {
    return ModelConfig(
      className: className ?? this.className,
      jsonMap: jsonMap ?? this.jsonMap,
      options: options ?? this.options,
    );
  }
}
