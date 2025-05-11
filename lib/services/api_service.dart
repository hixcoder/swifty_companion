// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://api.intra.42.fr/v2';

  // Fetch user data by login
  static Future<User?> getUserByLogin(String login) async {
    try {
      final client = await AuthService.getClient();
      final response = await client.get(Uri.parse('$baseUrl/users/$login'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
      rethrow; // Re-throw to handle in UI
    }
  }

  // Fetch user projects
  static Future<List<dynamic>> getUserProjects(String login) async {
    try {
      final client = await AuthService.getClient();
      final response =
          await client.get(Uri.parse('$baseUrl/users/$login/projects_users'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching projects: $e');
      rethrow;
    }
  }

  // Fetch user skills
  static Future<List<dynamic>> getUserSkills(String login) async {
    try {
      final client = await AuthService.getClient();
      final response =
          await client.get(Uri.parse('$baseUrl/users/$login/cursus_users'));

      if (response.statusCode == 200) {
        final List<dynamic> cursusUsers = json.decode(response.body);
        if (cursusUsers.isNotEmpty) {
          // Get the 42 cursus (id = 21) or the first one
          final cursusUser = cursusUsers.firstWhere(
              (cu) => cu['cursus_id'] == 21,
              orElse: () => cursusUsers[0]);

          if (cursusUser != null && cursusUser['skills'] != null) {
            return cursusUser['skills'];
          }
        }
        return [];
      } else {
        throw Exception('Failed to load skills: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching skills: $e');
      rethrow;
    }
  }
}
