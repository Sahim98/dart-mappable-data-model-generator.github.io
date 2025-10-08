import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/model_config.dart';
import '../models/mappable_options.dart';
import '../services/code_generator.dart';
import 'dart:convert';

final modelProvider =
    StateNotifierProvider<ModelNotifier, ModelConfig>((ref) => ModelNotifier());

class ModelNotifier extends StateNotifier<ModelConfig> {
  ModelNotifier() : super(ModelConfig.initial());

  void setClassName(String name) =>
      state = state.copyWith(className: name);

  void setOptions(MappableOptions options) =>
      state = state.copyWith(options: options);

  void updateFromJson(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        state = state.copyWith(jsonMap: decoded);
      }
    } catch (_) {
      state = state.copyWith(jsonMap: {});
    }
  }

  String get generatedCode => generateClassFromJson(
      state.className, state.jsonMap, state.options);
}
