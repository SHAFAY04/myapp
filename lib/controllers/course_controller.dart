import 'package:flutter/foundation.dart';

import '../core/enums/api_state_enum.dart';
import '../models/course_model.dart';
import '../services/course_api_service.dart';

/// Controller layer: owns all course business logic and exposes reactive
/// state via [ChangeNotifier]. The UI only reads state and calls methods —
/// it never touches [CourseApiService] directly.
class CourseController extends ChangeNotifier {
  final CourseApiService _api = CourseApiService.instance;

  // ─── State ────────────────────────────────────────────────────────────────
  ApiState _listState = ApiState.initial;
  ApiState _mutationState = ApiState.initial; // create / update / delete
  List<CourseModel> _courses = [];
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────
  ApiState get listState => _listState;
  ApiState get mutationState => _mutationState;
  List<CourseModel> get courses => List.unmodifiable(_courses);
  String? get errorMessage => _errorMessage;
  bool get isListLoading => _listState.isLoading;
  bool get isMutating => _mutationState.isLoading;

  // ─── READ ─────────────────────────────────────────────────────────────────
  Future<void> fetchCourses({int limit = 20}) async {
    _listState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _api.fetchCourses(limit: limit);
      _listState = ApiState.success;
    } catch (e) {
      _listState = ApiState.error;
      _errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<bool> createCourse({
    required String title,
    required String description,
  }) async {
    _mutationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _api.createCourse(
        title: title.trim(),
        description: description.trim(),
      );

      // JSONPlaceholder always returns id=101; give it a unique local id
      // so the list stays usable across multiple creates.
      final localId = _nextLocalId();
      _courses.insert(0, created.copyWith(id: localId));

      _mutationState = ApiState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _mutationState = ApiState.error;
      _errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<bool> updateCourse(CourseModel updated) async {
    _mutationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // JSONPlaceholder only accepts PUT for ids 1-100; for locally-created
      // items (id > 100) we skip the network call but still update locally.
      CourseModel result;
      if (updated.id <= 100) {
        result = await _api.updateCourse(updated);
      } else {
        result = updated; // local-only item
      }

      final index = _courses.indexWhere((c) => c.id == updated.id);
      if (index != -1) _courses[index] = result;

      _mutationState = ApiState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _mutationState = ApiState.error;
      _errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<bool> deleteCourse(int id) async {
    _mutationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (id <= 100) {
        await _api.deleteCourse(id);
      }
      _courses.removeWhere((c) => c.id == id);

      _mutationState = ApiState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _mutationState = ApiState.error;
      _errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void clearMutationState() {
    _mutationState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  int _nextLocalId() {
    if (_courses.isEmpty) return 10001;
    final maxId = _courses.map((c) => c.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('socketexception') || msg.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (msg.contains('apiexception')) {
      return 'Server error. Please try again later.';
    }
    return 'Something went wrong. Please try again.';
  }
}
