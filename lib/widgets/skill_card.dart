// lib/widgets/skill_card.dart
import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;

  const SkillCard({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Improved header with level badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skill name with better typography
                Expanded(
                  child: Text(
                    skill.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                // Level indicator as a circular badge
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getColorForLevel(skill.level).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getColorForLevel(skill.level).withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '${skill.level.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _getColorForLevel(skill.level),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Percentage indicator with text
            Row(
              children: [
                Text(
                  'Mastery',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${skill.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getColorForLevel(skill.level),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Improved progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Background progress bar
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Filled progress bar with gradient
                  FractionallySizedBox(
                    widthFactor: skill.level / 21, // Assuming max level is 21
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getColorForLevel(skill.level).withOpacity(0.7),
                            _getColorForLevel(skill.level),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                _getColorForLevel(skill.level).withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add dots on the progress bar for visual interest
                  Container(
                    height: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 1,
                          height: 6,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get color based on skill level - improved color palette
  Color _getColorForLevel(double level) {
    if (level < 5) return Color(0xFFE57373); // Red 300
    if (level < 10) return Color(0xFFFFB74D); // Orange 300
    if (level < 15) return Color(0xFFFFF176); // Yellow 300
    return Color(0xFF81C784); // Green 300
  }
}
