import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/course_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/enums/api_state_enum.dart';
import '../../models/course_model.dart';
import 'course_form_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
    });
  }

  Future<void> _confirmDelete(CourseModel course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Course',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete\n"${course.title}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final controller = context.read<CourseController>();
      final success = await controller.deleteCourse(course.id);
      if (mounted) {
        _showSnack(
          success ? 'Course deleted successfully.' : controller.errorMessage!,
          isError: !success,
        );
      }
    }
  }

  void _openForm({CourseModel? course}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormScreen(existingCourse: course),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? AppConstants.errorColor : AppConstants.successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.surfaceColor,
      appBar: AppBar(
        title: const Text('API Courses',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => context.read<CourseController>().fetchCourses(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Course',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Consumer<CourseController>(
        builder: (_, controller, __) {
          // ── Loading ──────────────────────────────────────────────────────
          if (controller.listState.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppConstants.primaryColor),
                  SizedBox(height: 16),
                  Text('Fetching courses from API…',
                      style:
                          TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                ],
              ),
            );
          }

          // ── Error ────────────────────────────────────────────────────────
          if (controller.listState.isError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 64, color: Color(0xFFCBD5E1)),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage ?? 'Failed to load courses.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchCourses(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Empty ────────────────────────────────────────────────────────
          if (controller.courses.isEmpty) {
            return const Center(
              child: Text('No courses found.',
                  style: TextStyle(color: Color(0xFF64748B))),
            );
          }

          // ── List ─────────────────────────────────────────────────────────
          return Column(
            children: [
              _ApiInfoBanner(),
              Expanded(
                child: RefreshIndicator(
                  color: AppConstants.primaryColor,
                  onRefresh: controller.fetchCourses,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: controller.courses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => _CourseCard(
                      course: controller.courses[index],
                      onEdit: () =>
                          _openForm(course: controller.courses[index]),
                      onDelete: () => _confirmDelete(controller.courses[index]),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _ApiInfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppConstants.primaryColor.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.cloud_done_rounded,
              size: 16, color: AppConstants.primaryColor),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Data from JSONPlaceholder API  ·  jsonplaceholder.typicode.com',
              style: TextStyle(
                  fontSize: 11,
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ID: ${course.id}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                // Edit
                _ActionIcon(
                  icon: Icons.edit_rounded,
                  tooltip: 'Edit',
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                // Delete
                _ActionIcon(
                  icon: Icons.delete_rounded,
                  tooltip: 'Delete',
                  onTap: onDelete,
                  isDestructive: true,
                ),
              ],
            ),
          ),
          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppConstants.errorColor.withOpacity(0.9)
                : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
