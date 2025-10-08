import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/model_provider.dart';

class TopPanel extends ConsumerStatefulWidget {
  const TopPanel({super.key});

  @override
  ConsumerState<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends ConsumerState<TopPanel> {
  late final TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    final model = ref.read(modelProvider);
    _classController = TextEditingController(text: model.className);
    _classController.addListener(() {
      ref.read(modelProvider.notifier).setClassName(_classController.text);
    });
  }

  @override
  void dispose() {
    _classController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(modelProvider);
    final notifier = ref.read(modelProvider.notifier);

    if (_classController.text != model.className) {
      _classController.text = model.className;
      _classController.selection = TextSelection.fromPosition(
        TextPosition(offset: _classController.text.length),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 8,
        children: [
          SizedBox(
            width: 180,
            child: TextField(
              controller: _classController,
              decoration: InputDecoration(
                labelText: 'Class Name',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
          DropdownButton<String>(
            value: model.options.caseStyle,
            items: [
              'camelCase',
              'snakeCase',
              'pascalCase',
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) =>
                notifier.setOptions(model.options.copyWith(caseStyle: v)),
          ),
          Wrap(
            spacing: 8,
            children: ['Encode', 'Decode'].map((method) {
              final selected = model.options.generateMethods.contains(method);
              return FilterChip(
                label: Text(method),
                selected: selected,
                onSelected: (v) {
                  final list = [...model.options.generateMethods];
                  if (v) {
                    list.add(method);
                  } else {
                    list.remove(method);
                  }
                  notifier.setOptions(
                    model.options.copyWith(generateMethods: list),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
