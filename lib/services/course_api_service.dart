import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course_model.dart';

/// Pure service layer — all JSONPlaceholder HTTP calls live here.
/// Uses the `http` package so it works on Android, iOS, and Web.
/// Reference: https://jsonplaceholder.typicode.com/guide
class CourseApiService {
  CourseApiService._();
  static final CourseApiService instance = CourseApiService._();

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 15);

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // ─── CRUD ─────────────────────────────────────────────────────────────────

  /// GET /posts — fetch first [limit] courses.
  Future<List<CourseModel>> fetchCourses({int limit = 20}) async {
    final uri = Uri.parse('$_baseUrl/posts?_limit=$limit');
    final response = await http.get(uri).timeout(_timeout);
    _checkStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => CourseModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /posts/:id — fetch single course.
  Future<CourseModel> fetchCourse(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.get(uri).timeout(_timeout);
    _checkStatus(response);
    return CourseModel.fromMap(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// POST /posts — create a new course.
  /// JSONPlaceholder echoes back the payload with id = 101.
  Future<CourseModel> createCourse({
    required String title,
    required String description,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await http
        .post(
          uri,
          headers: _jsonHeaders,
          body: jsonEncode({
            'userId': userId,
            'title': title,
            'body': description,
          }),
        )
        .timeout(_timeout);
    _checkStatus(response);
    return CourseModel.fromMap(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// PUT /posts/:id — replace entire course.
  Future<CourseModel> updateCourse(CourseModel course) async {
    final uri = Uri.parse('$_baseUrl/posts/${course.id}');
    final response = await http
        .put(
          uri,
          headers: _jsonHeaders,
          body: jsonEncode(course.toMap()),
        )
        .timeout(_timeout);
    _checkStatus(response);
    return CourseModel.fromMap(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// DELETE /posts/:id — delete a course.
  Future<void> deleteCourse(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.delete(uri).timeout(_timeout);
    _checkStatus(response);
  }

  // ─── Helper ───────────────────────────────────────────────────────────────

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
          'HTTP ${response.statusCode}: ${response.body}',
          response.statusCode);
    }
  }
}

// ─── Exception ────────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
