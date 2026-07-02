import 'dart:async';

import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  static const _presets = [5, 10, 15, 25, 30, 45, 60];

  int _minutes = 25;
  int _seconds = 0;
  int _remaining = 25 * 60;
  Timer? _timer;
  bool _running = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remaining = _minutes * 60 + _seconds;
    });
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        setState(() => _running = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('时间到！')),
          );
        }
        return;
      }
      setState(() => _remaining--);
    });
  }

  String get _display {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('倒计时')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Text(_display,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 32),
            if (!_running) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _presets
                    .map((m) => ActionChip(
                          label: Text('${m}分钟'),
                          onPressed: () => setState(() {
                            _minutes = m;
                            _seconds = 0;
                            _remaining = m * 60;
                          }),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '分钟',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: '$_minutes'),
                      onSubmitted: (v) {
                        final m = int.tryParse(v) ?? _minutes;
                        setState(() {
                          _minutes = m.clamp(0, 999);
                          _remaining = _minutes * 60 + _seconds;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                  label: Text(_running ? '暂停' : '开始'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
