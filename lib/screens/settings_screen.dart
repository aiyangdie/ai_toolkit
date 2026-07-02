import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/settings_service.dart';
import '../services/user_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final user = context.watch<UserService>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
              ),
            ),
            title: Text(user.username.isEmpty ? '未登录' : user.username),
            subtitle: const Text('本地账户 · 数据仅存本机'),
          ),
        ),
        const SizedBox(height: 16),
        Text('外观', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('跟随系统'),
                value: ThemeMode.system,
                groupValue: settings.themeMode,
                onChanged: (v) {
                  if (v != null) settings.setThemeMode(v);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('浅色'),
                value: ThemeMode.light,
                groupValue: settings.themeMode,
                onChanged: (v) {
                  if (v != null) settings.setThemeMode(v);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('深色'),
                value: ThemeMode.dark,
                groupValue: settings.themeMode,
                onChanged: (v) {
                  if (v != null) settings.setThemeMode(v);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('关于', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('AiToolkit v1.0.0'),
            subtitle: Text('开源轻量工具箱 · Flutter 跨端\nGitHub: aiyangdie/ai_toolkit'),
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('退出登录'),
                content: const Text('确定退出？本地数据不会丢失。'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
                  FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('退出')),
                ],
              ),
            );
            if (ok == true && context.mounted) {
              await context.read<UserService>().logout();
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
        ),
      ],
    );
  }
}
