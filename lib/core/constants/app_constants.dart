import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ─── Storage keys ─────────────────────────────────────────────────────────
  static const String kUserEmailKey = 'user_email';
  static const String kUserFirstNameKey = 'user_first_name';
  static const String kUserLastNameKey = 'user_last_name';
  static const String kUserGenderKey = 'user_gender';
  static const String kIsLoggedInKey = 'is_logged_in';
  static const String kRememberMeKey = 'remember_me';
  static const String kRegisteredUsersKey = 'registered_users';

  // ─── Routes ───────────────────────────────────────────────────────────────
  static const String routeRegistration = '/register';
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';
  static const String routeDetail = '/detail';
  static const String routeCourses = '/courses';

  // ─── Theme colours ────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF4F46E5);   // indigo-600
  static const Color primaryLight = Color(0xFF818CF8);   // indigo-400
  static const Color primaryDark = Color(0xFF3730A3);    // indigo-800
  static const Color accentColor = Color(0xFF06B6D4);    // cyan-500
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;

  // ─── Subject data ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> subjects = [
    {
      'id': 'mad_101',
      'title': 'Mobile App Development',
      'code': 'MAD-101',
      'description':
          'An in-depth course covering the design, development, and deployment of cross-platform mobile applications. Students explore UI/UX principles, state management, RESTful API integration, local storage, and publishing to app stores using Flutter and Dart.',
      'schedule': 'Monday & Wednesday  •  9:00 AM – 10:30 AM',
      'room': 'Room CS-204',
      'instructor': 'Dr. Ayesha Siddiqui',
      'credits': 3,
      'icon': '📱',
      'gradient': [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    },
    {
      'id': 'sre_202',
      'title': 'Software Re-engineering',
      'code': 'SRE-202',
      'description':
          'This course focuses on the methodologies and tools used to modernise legacy software systems. Topics include reverse engineering, refactoring, migration strategies, automated testing, and maintaining software quality throughout the re-engineering lifecycle.',
      'schedule': 'Tuesday & Thursday  •  11:00 AM – 12:30 PM',
      'room': 'Room CS-108',
      'instructor': 'Prof. Khalid Mehmood',
      'credits': 3,
      'icon': '🔧',
      'gradient': [Color(0xFF0891B2), Color(0xFF06B6D4)],
    },
    {
      'id': 'mis_303',
      'title': 'Management Information Systems',
      'code': 'MIS-303',
      'description':
          'Explores the strategic role of information systems in organisations. Covers database management, ERP systems, business intelligence, decision support, cybersecurity governance, and the ethical implications of data-driven management practices.',
      'schedule': 'Friday  •  2:00 PM – 5:00 PM',
      'room': 'Room BS-301',
      'instructor': 'Dr. Nadia Rahman',
      'credits': 3,
      'icon': '📊',
      'gradient': [Color(0xFF059669), Color(0xFF10B981)],
    },
  ];
}
