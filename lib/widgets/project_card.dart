// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),

                // Project name
                Expanded(
                  child: Text(
                    project.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Project mark
                if (project.status == 'finished')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: project.isPassed
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${project.finalMark}',
                      style: TextStyle(
                        color: project.isPassed
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),

            // Project status
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                _getStatusText(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (project.isInProgress) return Colors.blue;
    if (project.isPassed) return Colors.green;
    if (project.isFailed) return Colors.red;
    return Colors.grey;
  }

  String _getStatusText() {
    if (project.isInProgress) return 'In Progress';
    if (project.isPassed) return 'Completed Successfully';
    if (project.isFailed) return 'Failed';
    if (project.status == 'waiting_for_correction')
      return 'Waiting for Correction';
    return project.status.replaceAll('_', ' ').capitalize();
  }
}

// Extension to capitalize first letter of each word
extension StringExtension on String {
  String capitalize() {
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
