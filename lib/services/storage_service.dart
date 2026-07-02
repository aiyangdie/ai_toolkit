import 'package:hive_flutter/hive_flutter.dart';

import '../models/habit.dart';
import '../models/note.dart';

class NoteRepository {
  Box get _box => Hive.box('notes_data');

  List<Note> getAll() {
    final raw = _box.get('list', defaultValue: <dynamic>[]) as List;
    return raw
        .map((e) => Note.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> save(Note note) async {
    final list = getAll();
    final index = list.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      list[index] = note;
    } else {
      list.insert(0, note);
    }
    await _persist(list);
  }

  Future<void> delete(String id) async {
    final list = getAll()..removeWhere((n) => n.id == id);
    await _persist(list);
  }

  Future<void> _persist(List<Note> list) async {
    await _box.put('list', list.map((n) => n.toMap()).toList());
  }
}

class HabitRepository {
  Box get _box => Hive.box('habits_data');

  List<Habit> getAll() {
    final raw = _box.get('list', defaultValue: <dynamic>[]) as List;
    return raw
        .map((e) => Habit.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> save(Habit habit) async {
    final list = getAll();
    final index = list.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      list[index] = habit;
    } else {
      list.add(habit);
    }
    await _box.put('list', list.map((h) => h.toMap()).toList());
  }

  Future<void> delete(String id) async {
    final list = getAll()..removeWhere((h) => h.id == id);
    await _box.put('list', list.map((h) => h.toMap()).toList());
  }
}
