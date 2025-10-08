class MappableOptions {
  final bool ignoreNull;
  final String caseStyle;
  final List<String> generateMethods; // e.g., ['Encode', 'Decode']

  MappableOptions({
    required this.ignoreNull,
    required this.caseStyle,
    required this.generateMethods,
  });

  factory MappableOptions.initial() => MappableOptions(
    ignoreNull: true,
    caseStyle: 'camelCase',
    generateMethods: ['Encode', 'Decode'],
  );

  MappableOptions copyWith({
    bool? ignoreNull,
    String? caseStyle,
    List<String>? generateMethods,
  }) {
    return MappableOptions(
      ignoreNull: ignoreNull ?? this.ignoreNull,
      caseStyle: caseStyle ?? this.caseStyle,
      generateMethods: generateMethods ?? this.generateMethods,
    );
  }
}
