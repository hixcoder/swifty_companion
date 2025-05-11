// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:swifty_companion/models/skill.dart';
import '../models/user.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedSkillIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D2027), // Dark background like in the example
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile refreshed'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.all(16),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header section with profile info
              _buildProfileHeader(context),

              // Skills radar chart section
              _buildSkillsRadarChart(context),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100, bottom: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B303A),
            Color(0xFF1D2027),
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: widget.user.imageUrl != null
                  ? Image.network(
                      widget.user.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade800,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white70,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade800,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 16),

          // User name and login
          Text(
            widget.user.displayName ?? widget.user.login,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 4),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.user.login,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Email info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 18,
                color: Colors.white70,
              ),
              SizedBox(width: 8),
              Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Stats cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildStatCard(
                  "Level",
                  widget.user.level.toStringAsFixed(2),
                  Color(0xFF4568DC),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  "Wallet",
                  "${widget.user.wallet}",
                  Color(0xFF43A047),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  "Points",
                  widget.user.correction_point ?? "0",
                  Color(0xFFFB8C00),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsRadarChart(BuildContext context) {
    // Take top skills for the radar chart
    final topSkills = widget.user.skills.take(6).toList();

    if (topSkills.isEmpty) {
      return _buildEmptySkillsState();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title configuration options (similar to the example)
          Text(
            'Title configuration',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          Row(
            children: [
              Text(
                'Angle',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Expanded(
                child: Slider(
                  value: angleValue,
                  max: 360,
                  activeColor: Colors.purple[200],
                  inactiveColor: Colors.grey[800],
                  onChanged: (double value) =>
                      setState(() => angleValue = value),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Checkbox(
                value: relativeAngleMode,
                fillColor: MaterialStateProperty.resolveWith(
                  (states) => states.contains(MaterialState.selected)
                      ? Colors.purple[200]
                      : Colors.grey[600],
                ),
                onChanged: (v) => setState(() => relativeAngleMode = v!),
              ),
              Text(
                'Relative',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          // Skills title and legend
          Text(
            'SKILLS',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 16),

          // Legend with skills list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: topSkills
                .asMap()
                .map((index, skill) {
                  final isSelected = index == selectedSkillIndex;
                  final color = _getSkillColor(index);

                  return MapEntry(
                    index,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSkillIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              skill.name,
                              style: TextStyle(
                                color: isSelected ? color : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              skill.level.toStringAsFixed(1),
                              style: TextStyle(
                                color: isSelected ? color : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),

          SizedBox(height: 24),

          // Radar chart
          AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                dataSets: showingDataSets(topSkills),
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle: TextStyle(color: Colors.white70, fontSize: 10),
                getTitle: (index, angle) {
                  final usedAngle =
                      relativeAngleMode ? angle + angleValue : angleValue;
                  if (index < topSkills.length) {
                    return RadarChartTitle(
                      text: topSkills[index].name,
                      angle: usedAngle,
                    );
                  }
                  return RadarChartTitle(text: "");
                },
                tickCount: 5,
                ticksTextStyle:
                    TextStyle(color: Colors.transparent, fontSize: 10),
                tickBorderData: BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: Colors.white30, width: 1),
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets(List<Skill> skills) {
    // Create a single RadarDataSet for selected skill or all skills
    if (selectedSkillIndex >= 0 && selectedSkillIndex < skills.length) {
      // Show only selected skill
      return [
        RadarDataSet(
          fillColor: _getSkillColor(selectedSkillIndex).withOpacity(0.2),
          borderColor: _getSkillColor(selectedSkillIndex),
          entryRadius: 3,
          dataEntries: skills.map((skill) {
            int index = skills.indexOf(skill);
            if (index == selectedSkillIndex) {
              return RadarEntry(value: skill.level);
            } else {
              return RadarEntry(value: 0);
            }
          }).toList(),
          borderWidth: 2.3,
        )
      ];
    } else {
      // Show all skills
      return skills.asMap().entries.map((entry) {
        final index = entry.key;
        final skill = entry.value;

        return RadarDataSet(
          fillColor: _getSkillColor(index).withOpacity(0.1),
          borderColor: _getSkillColor(index),
          entryRadius: 2,
          dataEntries: skills.map((s) {
            int sIndex = skills.indexOf(s);
            if (sIndex == index) {
              return RadarEntry(value: s.level);
            } else {
              return RadarEntry(value: 0);
            }
          }).toList(),
          borderWidth: 2,
        );
      }).toList();
    }
  }

  Widget _buildEmptySkillsState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radar_rounded,
              size: 64,
              color: Colors.grey[600],
            ),
            SizedBox(height: 16),
            Text(
              "No skills found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Skills will appear here once they're available",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSkillColor(int index) {
    // Predefined color array for different skills
    final colors = [
      Color(0xFFFF3F80), // Pink (Fashion)
      Color(0xFF00D5E0), // Cyan (Art & Tech)
      Color(0xFFFFFFFF), // White (Entertainment)
      Color(0xFFFFD700), // Yellow (Off-road Vehicle)
      Color(0xFF64DD17), // Green (Boxing)
      Color(0xFF7B68EE), // Purple (Additional color)
    ];

    // Return color based on index or use a default
    if (index >= 0 && index < colors.length) {
      return colors[index];
    }

    // Default color based on level for any additional skills
    final skill = widget.user.skills[index];
    if (skill.level < 5) return Color(0xFFF44336); // Red
    if (skill.level < 10) return Color(0xFFFF9800); // Orange
    if (skill.level < 15) return Color(0xFF2196F3); // Blue
    return Color(0xFF4CAF50); // Green
  }
}
