import 'package:flutter/material.dart';
import 'package:quick_parse/ui/top_panel.dart';
import 'json_input.dart';
import 'code_preview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.generating_tokens),
            const SizedBox(width: 8),
            const Text('Dart Mappable Data Class Generator'),
          ],
        ),
      ),
      body: Column(
        children: [
          const TopPanel(),
          Expanded(
            child: Row(
              children: const [
                Expanded(child: JsonInput()),
                VerticalDivider(width: 1),
                Expanded(child: CodePreview()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
