import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _repo = HabitRepository();
  late List<Habit> _habits;
  final _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _habits = _repo.getAll();
  }

  void _refresh() => setState(() => _habits = _repo.getAll());

  Future<void> _addHabit() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新建打卡'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '习惯名称，如：早起、运动',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await _repo.save(Habit(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        checkDates: [],
      ));
      _refresh();
    }
  }

  Future<void> _toggle(Habit habit) async {
    await _repo.save(habit.toggleToday(_today));
    _refresh();
  }

  Future<void> _delete(Habit habit) async {
    await _repo.delete(habit.id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (_habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            const Text('创建你的第一个打卡习惯'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _addHabit,
              icon: const Icon(Icons.add),
              label: const Text('新建打卡'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: _habits.length,
          itemBuilder: (context, i) {
            final habit = _habits[i];
            final checked = habit.isCheckedToday(_today);
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: checked,
                  onChanged: (_) => _toggle(habit),
                ),
                title: Text(habit.name),
                subtitle: Text('累计 ${habit.checkDates.length} 天'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(habit),
                ),
                onTap: () => _toggle(habit),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _addHabit,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
