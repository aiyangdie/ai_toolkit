import 'package:flutter_test/flutter_test.dart';
import 'package:ai_toolkit/models/habit.dart';
import 'package:ai_toolkit/models/note.dart';

void main() {
  test('Note serializes and deserializes', () {
    final note = Note(
      id: '1',
      title: 'Test',
      content: 'Hello',
      updatedAt: DateTime(2026, 1, 1),
    );
    final restored = Note.fromMap(note.toMap());
    expect(restored.id, '1');
    expect(restored.title, 'Test');
    expect(restored.content, 'Hello');
  });

  test('Habit toggle today', () {
    final habit = Habit(id: '1', name: 'Run', checkDates: []);
    final toggled = habit.toggleToday('2026-07-02');
    expect(toggled.isCheckedToday('2026-07-02'), isTrue);
    expect(toggled.toggleToday('2026-07-02').isCheckedToday('2026-07-02'), isFalse);
  });
}
