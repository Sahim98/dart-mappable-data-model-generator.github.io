import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_parse/models/model_config.dart';
import 'package:quick_parse/utils/enum/conversion_mode_enum.dart';
import '../providers/model_provider.dart';

class TopPanel extends ConsumerStatefulWidget {
  const TopPanel({super.key});

  @override
  ConsumerState<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends ConsumerState<TopPanel> {
  late final TextEditingController _classNameController;

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController();

    // Defer provider read until after first frame to prevent white screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final model = ref.read(modelProvider);
        _classNameController.text = model.className;
        _classNameController.addListener(() {
          ref
              .read(modelProvider.notifier)
              .setClassName(_classNameController.text);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant TopPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final model = ref.read(modelProvider);
    if (_classNameController.text != model.className) {
      _classNameController.text = model.className;
      _classNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: model.className.length),
      );
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(modelProvider);
    final modelData = ref.read(modelProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(12),
            isSelected: [
              model.mode == ConversionMode.jsonToModel,
              model.mode == ConversionMode.modelToEntity,
            ],
            onPressed: (index) {
              modelData.setMode(
                index == 0
                    ? ConversionMode.jsonToModel
                    : ConversionMode.modelToEntity,
              );
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('JSON → Model'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('Model → Entity'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (model.mode == ConversionMode.jsonToModel)
            _buildJsonOptions(ref, model, modelData)
          else
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Paste your Data Model on the left. Generated Entity & Model will appear on the right.',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJsonOptions(
    WidgetRef ref,
    ModelConfig model,
    ModelNotifier modelData,
  ) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 180,
          child: TextField(
            controller: _classNameController,
            decoration: const InputDecoration(labelText: 'Class Name'),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ignore Null'),
            Switch(
              value: model.options.ignoreNull,
              onChanged: (v) =>
                  modelData.setOptions(model.options.copyWith(ignoreNull: v)),
            ),
          ],
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Generate Encode'),
            Checkbox(
              value: model.options.generateMethods.contains('encode'),
              onChanged: (v) {
                final methods = List<String>.from(
                  model.options.generateMethods,
                );
                if (v == true) {
                  if (!methods.contains('encode')) methods.add('encode');
                } else {
                  methods.remove('encode');
                }
                modelData.setOptions(
                  model.options.copyWith(generateMethods: methods),
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Generate Decode'),
            Checkbox(
              value: model.options.generateMethods.contains('decode'),
              onChanged: (v) {
                final methods = List<String>.from(
                  model.options.generateMethods,
                );
                if (v == true) {
                  if (!methods.contains('decode')) methods.add('decode');
                } else {
                  methods.remove('decode');
                }
                modelData.setOptions(
                  model.options.copyWith(generateMethods: methods),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
