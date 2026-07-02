import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _input = TextEditingController(text: '1');

  static const _lengthUnits = ['米', '千米', '厘米', '英里', '英尺'];
  static const _lengthToMeter = [1.0, 1000.0, 0.01, 1609.344, 0.3048];

  static const _weightUnits = ['千克', '克', '磅', '盎司'];
  static const _weightToKg = [1.0, 0.001, 0.453592, 0.0283495];

  int _fromIndex = 0;
  int _toIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _input.dispose();
    super.dispose();
  }

  double _convert(double value, List<double> factors, int from, int to) {
    final base = value * factors[from];
    return base / factors[to];
  }

  Widget _buildConverter(List<String> units, List<double> factors) {
    final value = double.tryParse(_input.text) ?? 0;
    final result = _convert(value, factors, _fromIndex, _toIndex);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _input,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '输入数值',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _fromIndex,
                  decoration: const InputDecoration(
                    labelText: '从',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i < units.length; i++)
                      DropdownMenuItem(value: i, child: Text(units[i])),
                  ],
                  onChanged: (v) => setState(() => _fromIndex = v ?? 0),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () => setState(() {
                  final tmp = _fromIndex;
                  _fromIndex = _toIndex;
                  _toIndex = tmp;
                }),
              ),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _toIndex,
                  decoration: const InputDecoration(
                    labelText: '到',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i < units.length; i++)
                      DropdownMenuItem(value: i, child: Text(units[i])),
                  ],
                  onChanged: (v) => setState(() => _toIndex = v ?? 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '${result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')} ${units[_toIndex]}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _convertTemp(double value, int from, int to) {
    double celsius;
    switch (from) {
      case 0:
        celsius = value;
      case 1:
        celsius = (value - 32) * 5 / 9;
      default:
        celsius = value - 273.15;
    }
    switch (to) {
      case 0:
        return celsius;
      case 1:
        return celsius * 9 / 5 + 32;
      default:
        return celsius + 273.15;
    }
  }

  Widget _buildTempConverter() {
    const units = ['摄氏度 °C', '华氏度 °F', '开尔文 K'];
    final value = double.tryParse(_input.text) ?? 0;
    final result = _convertTemp(value, _fromIndex.clamp(0, 2), _toIndex.clamp(0, 2));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _input,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '输入温度',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _fromIndex.clamp(0, 2),
                  decoration: const InputDecoration(
                    labelText: '从',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i < units.length; i++)
                      DropdownMenuItem(value: i, child: Text(units[i])),
                  ],
                  onChanged: (v) => setState(() => _fromIndex = v ?? 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _toIndex.clamp(0, 2),
                  decoration: const InputDecoration(
                    labelText: '到',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i < units.length; i++)
                      DropdownMenuItem(value: i, child: Text(units[i])),
                  ],
                  onChanged: (v) => setState(() => _toIndex = v ?? 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '${result.toStringAsFixed(2)} ${units[_toIndex.clamp(0, 2)].split(' ').last}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单位换算'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {
            _fromIndex = 0;
            _toIndex = 1;
          }),
          tabs: const [
            Tab(text: '长度'),
            Tab(text: '重量'),
            Tab(text: '温度'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConverter(_lengthUnits, _lengthToMeter),
          _buildConverter(_weightUnits, _weightToKg),
          _buildTempConverter(),
        ],
      ),
    );
  }
}
