class MappableOptions {
  final bool ignoreNull;
  final String caseStyle; // e.g. "snakeCase", "camelCase", "pascalCase"
  final List<String> generateMethods; // e.g. ["toJson","fromJson","copyWith"]

  MappableOptions({
    this.ignoreNull = false,
    this.caseStyle = 'camelCase',
    List<String>? generateMethods,
  }) : generateMethods = generateMethods ?? [];

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
