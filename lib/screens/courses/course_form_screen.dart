import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/course_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/validators/app_validator.dart';
import '../../models/course_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Shared screen for both Add (POST) and Edit (PUT) operations.
/// If [existingCourse] is null → Add mode.
/// If [existingCourse] is provided → Edit mode (fields pre-filled).
class CourseFormScreen extends StatefulWidget {
  final CourseModel? existingCourse;

  const CourseFormScreen({super.key, this.existingCourse});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  bool _formValid = false;

  bool get _isEdit => widget.existingCourse != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data if editing
    _titleController =
        TextEditingController(text: widget.existingCourse?.title ?? '');
    _descController =
        TextEditingController(text: widget.existingCourse?.body ?? '');

    // Evaluate initial validity (edit mode may already be valid)
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkValidity());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _checkValidity() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != _formValid) setState(() => _formValid = valid);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = context.read<CourseController>();
    bool success;

    if (_isEdit) {
      final updated = widget.existingCourse!.copyWith(
        title: _titleController.text.trim(),
        body: _descController.text.trim(),
      );
      success = await controller.updateCourse(updated);
    } else {
      success = await controller.createCourse(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      _showSnack(
        _isEdit ? 'Course updated successfully!' : 'Course added successfully!',
      );
      Navigator.pop(context);
    } else {
      _showSnack(controller.errorMessage ?? 'Operation failed.', isError: true);
    }
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
        title: Text(
          _isEdit ? 'Edit Course' : 'Add Course',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 28),
            _buildForm(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            if (_isEdit) ...[
              const SizedBox(height: 12),
              _buildMethodBadge('PUT /posts/${widget.existingCourse!.id}'),
            ] else ...[
              const SizedBox(height: 12),
              _buildMethodBadge('POST /posts'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (_isEdit
                    ? AppConstants.accentColor
                    : AppConstants.primaryColor)
                .withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _isEdit ? Icons.edit_note_rounded : Icons.add_box_rounded,
            color: _isEdit
                ? AppConstants.accentColor
                : AppConstants.primaryColor,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Update Course' : 'New Course',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              _isEdit
                  ? 'Modify the course details below'
                  : 'Fill in the details to create a course',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      onChanged: _checkValidity,
      child: Column(
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Course Title',
            hint: 'e.g. Introduction to Flutter',
            prefixIcon: Icons.menu_book_rounded,
            validator: (v) => AppValidator.validateNotEmpty(v, 'Course title'),
            onChanged: (_) => _checkValidity(),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          // Multi-line description
          TextFormField(
            controller: _descController,
            maxLines: 5,
            minLines: 4,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) =>
                AppValidator.validateNotEmpty(v, 'Description'),
            onChanged: (_) => _checkValidity(),
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Provide a brief course overview…',
              hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 13),
              labelStyle:
                  const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              alignLabelWithHint: true,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 52),
                child: Icon(Icons.description_outlined,
                    color: AppConstants.primaryColor, size: 20),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppConstants.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppConstants.errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppConstants.errorColor, width: 2),
              ),
              errorStyle:
                  const TextStyle(fontSize: 12, color: AppConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<CourseController>(
      builder: (_, controller, __) => CustomButton(
        label: _isEdit ? 'Update Course' : 'Create Course',
        icon: _isEdit ? Icons.save_rounded : Icons.cloud_upload_rounded,
        isLoading: controller.isMutating,
        onPressed: _formValid ? _submit : null,
      ),
    );
  }

  Widget _buildMethodBadge(String endpoint) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _isEdit
                    ? AppConstants.accentColor
                    : AppConstants.successColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _isEdit ? 'PUT' : 'POST',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              endpoint,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
