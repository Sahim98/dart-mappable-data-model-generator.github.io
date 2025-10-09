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
    final model = ref.read(modelProvider);
    _classNameController = TextEditingController(text: model.className);
    _classNameController.addListener(() {
      ref.read(modelProvider.notifier).setClassName(_classNameController.text);
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
    final notifier = ref.read(modelProvider.notifier);

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
              notifier.setMode(
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
            _buildJsonOptions(ref, model, notifier)
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
      WidgetRef ref, ModelConfig model, ModelNotifier notifier) {
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
                  notifier.setOptions(model.options.copyWith(ignoreNull: v)),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Null Safety'),
            Switch(
              value: model.nullSafety,
              onChanged: (v) =>
                  notifier.state = notifier.state.copyWith(nullSafety: v),
            ),
          ],
        ),
      ],
    );
  }
}
