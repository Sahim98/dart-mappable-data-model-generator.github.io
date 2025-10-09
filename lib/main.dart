import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_parse/ui/generator_screen.dart';

void main() {
  runApp(const ProviderScope(child: MappableApp()));
}

class MappableApp extends StatelessWidget {
  const MappableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Parse Mappable Generator',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const GeneratorScreen(),
    );
  }
}
