
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/model_provider.dart';

class JsonInput extends ConsumerStatefulWidget {
  const JsonInput({super.key});

  @override
  ConsumerState<JsonInput> createState() => _JsonInputState();
}

class _JsonInputState extends ConsumerState<JsonInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Add listener to detect all changes including paste
    _controller.addListener(() {
      final text = _controller.text;
      ref.read(modelProvider.notifier).updateFromJson(text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JSON Input',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              textAlign: TextAlign.start,
              controller: _controller,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top, // cursor at top
              decoration: InputDecoration(
                hintText: 'Example: { "id": 1, "name": "John" }',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
