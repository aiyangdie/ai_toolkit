class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.checkDates,
  });

  final String id;
  final String name;
  final List<String> checkDates;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'checkDates': checkDates,
      };

  factory Habit.fromMap(Map<dynamic, dynamic> map) => Habit(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        checkDates: (map['checkDates'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  bool isCheckedToday(String today) => checkDates.contains(today);

  Habit toggleToday(String today) {
    final dates = List<String>.from(checkDates);
    if (dates.contains(today)) {
      dates.remove(today);
    } else {
      dates.add(today);
    }
    return Habit(id: id, name: name, checkDates: dates);
  }
}
