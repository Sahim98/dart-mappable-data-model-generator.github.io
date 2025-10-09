import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_parse/models/model_config.dart';
import 'package:quick_parse/ui/code_preview.dart';
import 'package:quick_parse/ui/top_panel.dart';
import '../providers/model_provider.dart';
import 'package:quick_parse/utils/enum/conversion_mode_enum.dart';

class GeneratorScreen extends ConsumerWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(modelProvider);
    final notifier = ref.read(modelProvider.notifier);

    final outputs = notifier.generatedOutputs;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🟦 Top options panel (mode selector, toggles, etc.)
          const TopPanel(),

          const Divider(height: 0),

          /// 🟨 Main content area
          Expanded(
            child: Row(
              children: [
                /// 🧩 Left Input Box
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.mode == ConversionMode.jsonToModel
                              ? 'JSON Input'
                              : 'Model Input',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                              text: model.mode == ConversionMode.jsonToModel
                                  ? _prettyJson(model.jsonMap)
                                  : model.rawModelInput,
                            ),
                            onChanged: (value) {
                              if (model.mode == ConversionMode.jsonToModel) {
                                notifier.updateFromJson(value);
                              } else {
                                notifier.setRawModelInput(value);
                              }
                            },
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const VerticalDivider(width: 0),

                /// 🧩 Right Output Preview(s)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildOutputArea(context, model, outputs),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputArea(
    BuildContext context,
    ModelConfig model,
    Map<String, String> outputs,
  ) {
    if (model.mode == ConversionMode.jsonToModel) {
      // single preview
      return CodePreview(
        title: 'Data Model',
        code: outputs['model']?.isEmpty ?? true
            ? '//No code generated yet for model....'
            : outputs['model'] ?? '',
      );
    } else {
      log(
        "Generated outputs - Entity: ${outputs['entity']?.isEmpty == true ? '(empty)' : 'generated'}, Model: ${outputs['model']?.isEmpty == true ? '(empty)' : 'generated'}",
      );
      // dual preview side by side
      return Row(
        children: [
          Expanded(
            child: CodePreview(
              title: 'Entity',
              code: outputs['entity']!.length < 2
                  ? ('//No code generated yet for entity....').padRight(500, '\t') 
                  : outputs['entity'] ?? '',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CodePreview(
              title: 'Model',
              code: outputs['model']!.length < 2
                  ? ('//No code generated yet for model....').padRight(500, '\t')
                  : outputs['model'] ?? '',
            ),
          ),
        ],
      );
    }
  }

  String _prettyJson(Map<String, dynamic> json) {
    if (json.isEmpty) return '';
    try {
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (_) {
      return '';
    }
  }
}
