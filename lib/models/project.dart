class Project {
  final String name;
  final int finalMark;
  final String status;
  final String? slug;

  Project({
    required this.name,
    required this.finalMark,
    required this.status,
    this.slug,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['project']?['name'] ?? 'Unknown Project',
      slug: json['project']?['slug'],
      finalMark: json['final_mark'] ?? 0,
      status: json['status'] ?? 'unavailable',
    );
  }

  // Check if the project is passed (mark >= 50)
  bool get isPassed => finalMark >= 50 && status == 'finished';

  // Check if project is in progress
  bool get isInProgress => status == 'in_progress';

  // Check if project is failed
  bool get isFailed => status == 'finished' && finalMark < 50;
}
