class FieldModel {
  final String name;
  final String type; // e.g. "int", "String", "List<String>"
  final bool nullable;

  FieldModel({
    required this.name,
    required this.type,
    this.nullable = false,
  });

  FieldModel copyWith({String? name, String? type, bool? nullable}) {
    return FieldModel(
      name: name ?? this.name,
      type: type ?? this.type,
      nullable: nullable ?? this.nullable,
    );
  }
}
