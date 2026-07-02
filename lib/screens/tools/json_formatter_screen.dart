import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonFormatterScreen extends StatefulWidget {
  const JsonFormatterScreen({super.key});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen> {
  final _input = TextEditingController(
    text: '{"name":"AiToolkit","version":"1.0.0","features":["calc","notes"]}',
  );
  String _output = '';
  String? _error;

  void _format({bool minify = false}) {
    try {
      final decoded = jsonDecode(_input.text);
      setState(() {
        _output = minify
            ? jsonEncode(decoded)
            : const JsonEncoder.withIndent('  ').convert(decoded);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _output = '';
      });
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON 格式化')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _input,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: '输入 JSON',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilledButton(onPressed: () => _format(), child: const Text('美化')),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _format(minify: true),
                  child: const Text('压缩'),
                ),
                const Spacer(),
                IconButton(
                  tooltip: '复制结果',
                  onPressed: _output.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: _output));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已复制')),
                          );
                        },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _output.isEmpty ? '格式化结果将显示在这里' : _output,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
