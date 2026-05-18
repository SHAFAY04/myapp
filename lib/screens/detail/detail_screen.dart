import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../models/subject_model.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subject =
        ModalRoute.of(context)!.settings.arguments as SubjectModel;

    return Scaffold(
      backgroundColor: AppConstants.surfaceColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, subject),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBadge(subject),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.info_outline_rounded,
                    title: 'Course Overview',
                    color: subject.gradient.first,
                    child: Text(
                      subject.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        height: 1.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.calendar_today_rounded,
                    title: 'Schedule & Location',
                    color: subject.gradient.first,
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.access_time_rounded,
                          label: 'Class Timing',
                          value: subject.schedule,
                          color: subject.gradient.first,
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.room_rounded,
                          label: 'Room',
                          value: subject.room,
                          color: subject.gradient.first,
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.person_rounded,
                          label: 'Instructor',
                          value: subject.instructor,
                          color: subject.gradient.first,
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.star_rounded,
                          label: 'Credit Hours',
                          value: '${subject.credits} Credits',
                          color: subject.gradient.first,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.checklist_rounded,
                    title: 'Learning Outcomes',
                    color: subject.gradient.first,
                    child: Column(
                      children: [
                        _outcomeItem('Understand core theoretical concepts'),
                        _outcomeItem(
                            'Apply practical skills in real-world scenarios'),
                        _outcomeItem('Collaborate and communicate findings'),
                        _outcomeItem(
                            'Critically evaluate techniques and methodologies'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, SubjectModel subject) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: subject.gradient.first,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: subject.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      subject.icon,
                      style: const TextStyle(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subject.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject.code,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(SubjectModel subject) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: subject.gradient.map((c) => c.withOpacity(0.12)).toList(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: subject.gradient.first.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded,
              color: subject.gradient.first, size: 18),
          const SizedBox(width: 8),
          Text(
            'Enrolled · ${subject.credits} Credit Hours',
            style: TextStyle(
              color: subject.gradient.first,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 17),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _outcomeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 16, color: AppConstants.successColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF475569), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 1),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
