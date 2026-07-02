import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _length = 16;
  bool _upper = true;
  bool _lower = true;
  bool _digits = true;
  bool _symbols = false;
  String _password = '';

  void _generate() {
    final chars = StringBuffer();
    if (_upper) chars.write('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (_lower) chars.write('abcdefghijklmnopqrstuvwxyz');
    if (_digits) chars.write('0123456789');
    if (_symbols) chars.write('!@#\$%^&*-_=+');

    final pool = chars.toString();
    if (pool.isEmpty) {
      setState(() => _password = '');
      return;
    }

    final random = Random.secure();
    final result = List.generate(
      _length.round(),
      (_) => pool[random.nextInt(pool.length)],
    ).join();

    setState(() => _password = result);
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('密码生成器')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _password.isEmpty ? '请选择至少一种字符类型' : _password,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _generate,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新生成'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: _password.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: _password));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已复制到剪贴板')),
                        );
                      },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('长度: ${_length.round()}'),
          Slider(
            value: _length,
            min: 6,
            max: 32,
            divisions: 26,
            label: _length.round().toString(),
            onChanged: (v) => setState(() => _length = v),
          ),
          SwitchListTile(
            title: const Text('大写字母 A-Z'),
            value: _upper,
            onChanged: (v) => setState(() => _upper = v),
          ),
          SwitchListTile(
            title: const Text('小写字母 a-z'),
            value: _lower,
            onChanged: (v) => setState(() => _lower = v),
          ),
          SwitchListTile(
            title: const Text('数字 0-9'),
            value: _digits,
            onChanged: (v) => setState(() => _digits = v),
          ),
          SwitchListTile(
            title: const Text('符号 !@#...'),
            value: _symbols,
            onChanged: (v) => setState(() => _symbols = v),
          ),
        ],
      ),
    );
  }
}
