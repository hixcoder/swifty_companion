import 'package:swifty_companion/utils/function.dart';

import 'project.dart';
import 'skill.dart';
import 'dart:convert'; // Add this for JSON serialization

class User {
  final String login;
  final String email;
  final String? phone;
  final String? imageUrl;
  final double level;
  final String? location;
  final int wallet;
  final List<Skill> skills;
  final List<Project> projects;
  final String? displayName;
  final String? correction_point;

  User({
    required this.login,
    required this.email,
    this.phone,
    this.imageUrl,
    required this.level,
    this.location,
    required this.wallet,
    required this.skills,
    required this.projects,
    this.displayName,
    this.correction_point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Extract skills from cursus_users
    List<Skill> skills = [];
    if (json['cursus_users'] != null && json['cursus_users'].isNotEmpty) {
      var cursusUser = json['cursus_users']
          .firstWhere((cu) => cu['cursus_id'] == 21, // 42 cursus ID
              orElse: () => json['cursus_users'][0]);
      if (cursusUser != null && cursusUser['skills'] != null) {
        skills = List<Skill>.from(
            cursusUser['skills'].map((s) => Skill.fromJson(s)));
        // Sort skills by level (descending)
        skills.sort((a, b) => b.level.compareTo(a.level));
      }
    }

    // Extract projects from projects_users
    List<Project> projects = [];
    if (json['projects_users'] != null) {
      projects = List<Project>.from(
          json['projects_users'].map((p) => Project.fromJson(p)));
      // Sort projects: first by status, then by name
      projects.sort((a, b) {
        if (a.status != b.status) {
          // In progress first, then finished, then other statuses
          if (a.isInProgress) return -1;
          if (b.isInProgress) return 1;
          if (a.status == 'finished') return -1;
          if (b.status == 'finished') return 1;
        }
        return a.name.compareTo(b.name);
      });
    }

    // Extract level from cursus_users
    double level = 0.0;
    if (json['cursus_users'] != null && json['cursus_users'].isNotEmpty) {
      // Debug the cursus_users object properly by converting it to a string
      printLongString(jsonEncode(json['cursus_users'][0]));

      // Safely convert the level to double
      print("-----------bbbb--+++");
      printLongString(jsonEncode(json['cursus_users']));
      print("-----------bbbb--+++");
      var levelValue = json['cursus_users'][0]['level'];
      if (levelValue is double) {
        level = levelValue;
      } else if (levelValue is int) {
        level = levelValue.toDouble();
      } else if (levelValue is String) {
        level = double.tryParse(levelValue) ?? 0.0;
      } else if (levelValue is Map) {
        // If it's a map, try to extract a numeric value or use default
        level = 0.0;
        print("Warning: 'level' is a Map instead of a numeric value");
      }
    }

    return User(
      login: json['login'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      imageUrl: json["image"]['link'],
      level: level,
      location: json['location'],
      wallet: json['wallet'] ?? 0,
      skills: skills,
      projects: projects,
      displayName: json['displayname'] ?? json['login'],
      correction_point: json['correction_point']?.toString(),
    );
  }
}
