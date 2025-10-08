import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/model_provider.dart';

class CodePreview extends ConsumerStatefulWidget {
  const CodePreview({super.key});

  @override
  ConsumerState<CodePreview> createState() => _CodePreviewState();
}

class _CodePreviewState extends ConsumerState<CodePreview> {
  @override
  Widget build(BuildContext context) {
    ref.watch(modelProvider);
    final code = ref.read(modelProvider.notifier).generatedCode;
    log('code: $code');
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                },
                child: const Text('Copy to Clipboard'),
              ),
              const SizedBox(height: 12),
              // Text(
              //   code,
              //   style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              // ),
              SizedBox(
                width: double.infinity,
                child: HighlightView(
                  code,
                  language: 'dart',
                  theme: atomOneDarkTheme,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                  tabSize: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
