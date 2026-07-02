import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  void _tap(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _result = _evaluate(_expression);
      } else {
        _expression += value;
      }
    });
  }

  String _evaluate(String expr) {
    try {
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
      if (!RegExp(r'^[0-9+\-*/().\s]+$').hasMatch(expr)) return '错误';
      // Safe eval via simple parser
      final value = _parseExpression(expr);
      if (value.isNaN || value.isInfinite) return '错误';
      if (value == value.roundToDouble()) return value.toInt().toString();
      return value.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    } catch (_) {
      return '错误';
    }
  }

  double _parseExpression(String expr) {
    return _Parser(expr.replaceAll(' ', '')).parse();
  }

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['C', '⌫', '(', ')'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('计算器')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(_result,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ],
              ),
            ),
          ),
          for (final row in keys)
            Row(
              children: row
                  .map((k) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: k == '='
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              foregroundColor: k == '='
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _tap(k);
                            },
                            child: Text(k, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Parser {
  _Parser(this.input);
  final String input;
  int _pos = 0;

  double parse() => _parseExpression();

  double _parseExpression() {
    var value = _parseTerm();
    while (_pos < input.length && '+-'.contains(input[_pos])) {
      final op = input[_pos++];
      final right = _parseTerm();
      value = op == '+' ? value + right : value - right;
    }
    return value;
  }

  double _parseTerm() {
    var value = _parseFactor();
    while (_pos < input.length && '*/'.contains(input[_pos])) {
      final op = input[_pos++];
      final right = _parseFactor();
      value = op == '*' ? value * right : value / right;
    }
    return value;
  }

  double _parseFactor() {
    if (_pos < input.length && input[_pos] == '-') {
      _pos++;
      return -_parseFactor();
    }
    if (_pos < input.length && input[_pos] == '(') {
      _pos++;
      final value = _parseExpression();
      if (_pos < input.length && input[_pos] == ')') _pos++;
      return value;
    }
    return _parseNumber();
  }

  double _parseNumber() {
    final start = _pos;
    while (_pos < input.length && '0123456789.'.contains(input[_pos])) {
      _pos++;
    }
    return double.parse(input.substring(start, _pos));
  }
}
