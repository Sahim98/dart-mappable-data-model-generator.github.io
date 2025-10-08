import 'package:flutter/material.dart';
import 'package:quick_parse/ui/top_panel.dart';
import 'json_input.dart';
import 'code_preview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dart Mappable Parser UI')),
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
