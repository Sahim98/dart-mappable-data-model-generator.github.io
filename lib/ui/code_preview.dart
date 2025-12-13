import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';

class CodePreview extends StatefulWidget {
  final String title;
  final String code;
  final ValueChanged<String>? onCodeChanged;

  const CodePreview({
    super.key,
    required this.title,
    required this.code,
    this.onCodeChanged,
  });

  @override
  State<CodePreview> createState() => _CodePreviewState();
}

class _CodePreviewState extends State<CodePreview> {
  late TextEditingController _controller;
  String _lastCode = '';
  bool _previewMode = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.code);
    _lastCode = widget.code;
  }

  @override
  void didUpdateWidget(CodePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != _lastCode && _previewMode) {
      _controller.text = widget.code;
      _lastCode = widget.code;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏷️ Header row (title + copy button + toggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: _previewMode ? 'Edit code' : 'Preview code',
                      icon: Icon(
                        _previewMode ? Icons.edit : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _previewMode = !_previewMode;
                          if (!_previewMode) {
                            _lastCode = _controller.text;
                          }
                        });
                      },
                    ),
                    IconButton(
                      tooltip: 'Copy code',
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _controller.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.title} copied!'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 12),

            /// 🧩 Code display area - toggle between edit and preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _previewMode
                      ? (isDark ? Colors.black87 : const Color(0xFFf6f8fa))
                      : (isDark ?  Colors.grey[850] : 
                      const Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withAlpha(128),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: _previewMode
                    ? SingleChildScrollView(
                        child: HighlightView(
                          _controller.text.isEmpty
                              ? '// No code generated yet'
                              : _controller.text,
                          language: 'dart',
                          theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      )
                    : TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _lastCode = value;
                          widget.onCodeChanged?.call(value);
                        },
                        expands: true,
                        maxLines: null,
                        autofocus: true,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          height: 1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '// No code generated yet',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
