// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/skill_card.dart';
import '../widgets/project_card.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.login}\'s Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // In a real app, you'd refresh the user data here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Refreshed')),
          );
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile card
                _buildProfileCard(context),

                SizedBox(height: 24),

                // Skills section
                _buildSectionHeader(context, 'Skills'),
                _buildSkillsList(),

                SizedBox(height: 24),

                // Projects section
                _buildSectionHeader(context, 'Projects'),
                _buildProjectsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 56,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              backgroundImage:
                  user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
              child:
                  user.imageUrl == null ? Icon(Icons.person, size: 60) : null,
            ),

            SizedBox(height: 16),

            // User name
            Text(
              user.displayName ?? user.login,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            Text(
              user.login,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),

            Divider(height: 32),

            // User details
            _buildDetailRow(Icons.email, user.email),
            if (user.phone != null) _buildDetailRow(Icons.phone, user.phone!),
            _buildDetailRow(
                Icons.bar_chart, 'Level: ${user.level.toStringAsFixed(2)}'),
            if (user.location != null)
              _buildDetailRow(Icons.place, user.location!),
            _buildDetailRow(
                Icons.account_balance_wallet, 'Wallet: ${user.wallet}'),
            if (user.correction_point != null)
              _buildDetailRow(
                  Icons.star, 'Correction Points: ${user.correction_point}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Divider(thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsList() {
    if (user.skills.isEmpty) {
      return _buildEmptyState('No skills found');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: user.skills.length,
      itemBuilder: (context, index) {
        return SkillCard(skill: user.skills[index]);
      },
    );
  }

  Widget _buildProjectsList() {
    if (user.projects.isEmpty) {
      return _buildEmptyState('No projects found');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: user.projects.length,
      itemBuilder: (context, index) {
        return ProjectCard(project: user.projects[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
