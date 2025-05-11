class Skill {
  final String name;
  final double level;

  Skill({required this.name, required this.level});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? '',
      level: double.parse((json['level'] ?? 0).toString()),
    );
  }

  // Calculate the percentage completion of this skill (assuming max level is 21)
  double get percentage => (level / 21) * 100;
}
