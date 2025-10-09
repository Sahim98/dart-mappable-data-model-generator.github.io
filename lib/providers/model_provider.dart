import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_parse/utils/enum/conversion_mode_enum.dart';
import '../models/model_config.dart';
import '../models/mappable_options.dart';
import '../services/code_generator.dart';
import 'dart:convert';

final modelProvider = StateNotifierProvider<ModelNotifier, ModelConfig>(
  (ref) => ModelNotifier(),
);

class ModelNotifier extends StateNotifier<ModelConfig> {
  ModelNotifier() : super(ModelConfig.initial());

  void setMode(ConversionMode mode) => state = state.copyWith(mode: mode);

  void setClassName(String name) => state = state.copyWith(className: name);

  void setOptions(MappableOptions options) =>
      state = state.copyWith(options: options);

  void setNullSafety(bool nullSafety) =>
      state = state.copyWith(nullSafety: nullSafety);

  void setRawModelInput(String code) =>
      state = state.copyWith(rawModelInput: code);

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

  Map<String, String> get generatedOutputs {
    if (state.mode == ConversionMode.jsonToModel) {
      final code = generateClassFromJson(
        state.className,
        state.jsonMap,
        state.options,
      );
      return {'model': code};
    } else {
      final outputs = convertModelToEntity(state.rawModelInput);
      return {'entity': outputs['entity']!, 'model': outputs['model']!};
    }
  }
}
