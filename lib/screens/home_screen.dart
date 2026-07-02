import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart';
import 'tools/calculator_screen.dart';
import 'tools/converter_screen.dart';
import 'tools/countdown_screen.dart';
import 'tools/json_formatter_screen.dart';
import 'tools/password_generator_screen.dart';
import 'habits_screen.dart';
import 'notes_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _tabs = [
    _Tab('首页', Icons.home_rounded),
    _Tab('工具', Icons.build_rounded),
    _Tab('笔记', Icons.note_alt_rounded),
    _Tab('打卡', Icons.check_circle_outline),
    _Tab('我的', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserService>().username;
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_index].label),
        actions: [
          if (_index == 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text('Hi, $username',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          _DashboardTab(),
          _ToolsTab(),
          NotesScreen(),
          HabitsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }
}

class _Tab {
  const _Tab(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final tools = [
      _QuickTool('计算器', Icons.calculate, const CalculatorScreen()),
      _QuickTool('单位换算', Icons.swap_horiz, const ConverterScreen()),
      _QuickTool('倒计时', Icons.timer_outlined, const CountdownScreen()),
      _QuickTool('密码生成', Icons.key, const PasswordGeneratorScreen()),
      _QuickTool('JSON格式化', Icons.data_object, const JsonFormatterScreen()),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日快捷',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '8 大实用工具，全部离线运行，APK 体积精简。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('常用工具', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: tools
              .map((t) => _ToolCard(
                    label: t.label,
                    icon: t.icon,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => t.screen),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ToolsTab extends StatelessWidget {
  const _ToolsTab();

  @override
  Widget build(BuildContext context) {
    final items = [
      _ToolItem('计算器', '四则运算', Icons.calculate, const CalculatorScreen()),
      _ToolItem('单位换算', '长度/重量/温度', Icons.swap_horiz, const ConverterScreen()),
      _ToolItem('倒计时', '番茄钟计时', Icons.timer_outlined, const CountdownScreen()),
      _ToolItem('密码生成', '安全随机密码', Icons.key, const PasswordGeneratorScreen()),
      _ToolItem('JSON格式化', '美化/压缩', Icons.data_object, const JsonFormatterScreen()),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = items[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(item.icon)),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.screen),
            ),
          ),
        );
      },
    );
  }
}

class _QuickTool {
  const _QuickTool(this.label, this.icon, this.screen);
  final String label;
  final IconData icon;
  final Widget screen;
}

class _ToolItem {
  const _ToolItem(this.title, this.subtitle, this.icon, this.screen);
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
