// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getStatusColor().withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status indicator with more modern styling
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor().withOpacity(0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),

                // Project name with better typography
                Expanded(
                  child: Text(
                    project.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                // Project mark with improved styling
                if (project.status == 'finished')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: project.isPassed
                          ? Colors.green.withOpacity(0.15)
                          : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: project.isPassed
                            ? Colors.green.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${project.finalMark}',
                      style: TextStyle(
                        color: project.isPassed
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),

            // Add a subtle divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.15),
              ),
            ),

            // Project status with modern styling
            Row(
              children: [
                Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: _getStatusColor().withOpacity(0.1),
                  side: BorderSide(
                    color: _getStatusColor().withOpacity(0.3),
                    width: 1,
                  ),
                  avatar: Icon(
                    _getStatusIcon(),
                    size: 14,
                    color: _getStatusColor(),
                  ),
                  label: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor().withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                ),
              ],
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

  IconData _getStatusIcon() {
    if (project.isInProgress) return Icons.sync;
    if (project.isPassed) return Icons.check_circle;
    if (project.isFailed) return Icons.cancel;
    if (project.status == 'waiting_for_correction')
      return Icons.hourglass_empty;
    return Icons.info;
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
