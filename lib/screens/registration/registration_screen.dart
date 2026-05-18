import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/enums/auth_state_enum.dart';
import '../../core/enums/gender_enum.dart';
import '../../core/validators/app_validator.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Gender? _selectedGender;
  bool _formValid = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != _formValid) setState(() => _formValid = valid);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedGender == null) {
      _showSnack('Please select your gender.', isError: true);
      return;
    }

    final user = UserModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      gender: _selectedGender!,
    );

    final controller = context.read<AuthController>();
    final success = await controller.register(user);

    if (!mounted) return;

    if (success) {
      _showSuccessDialog();
    } else {
      _showSnack(controller.errorMessage ?? 'Registration failed.', isError: true);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppConstants.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppConstants.successColor, size: 44),
            ),
            const SizedBox(height: 16),
            const Text('Registration Successful!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Your account has been created. Please log in to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Go to Login',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AppConstants.routeLogin);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppConstants.errorColor : AppConstants.successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildLoginLink(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppConstants.primaryColor, AppConstants.primaryLight],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 20),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Fill in the details below to get started.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      onChanged: _checkFormValidity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name row ─────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'John',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => AppValidator.validateName(v, 'First name'),
                  onChanged: (_) => _checkFormValidity(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Doe',
                  validator: (v) => AppValidator.validateName(v, 'Last name'),
                  onChanged: (_) => _checkFormValidity(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Email ─────────────────────────────────────────────────────────
          CustomTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'john.doe@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidator.validateEmail,
            onChanged: (_) => _checkFormValidity(),
          ),
          const SizedBox(height: 16),

          // ── Gender dropdown ───────────────────────────────────────────────
          _buildGenderDropdown(),
          const SizedBox(height: 16),

          // ── Password ──────────────────────────────────────────────────────
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: AppValidator.validatePassword,
            onChanged: (_) => _checkFormValidity(),
          ),
          const SizedBox(height: 8),
          _buildPasswordRules(),
          const SizedBox(height: 16),

          // ── Confirm password ──────────────────────────────────────────────
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (v) => AppValidator.validateConfirmPassword(
                v, _passwordController.text),
            onChanged: (_) => _checkFormValidity(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<Gender>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        prefixIcon: const Icon(Icons.wc_rounded,
            color: AppConstants.primaryColor, size: 20),
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
          borderSide:
              const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
      ),
      hint: const Text('Select gender', style: TextStyle(fontSize: 14)),
      items: Gender.values
          .map((g) => DropdownMenuItem(
                value: g,
                child: Text(g.displayName, style: const TextStyle(fontSize: 14)),
              ))
          .toList(),
      validator: (_) => _selectedGender == null ? 'Please select a gender' : null,
      onChanged: (val) {
        setState(() => _selectedGender = val);
        _checkFormValidity();
      },
    );
  }

  Widget _buildPasswordRules() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    final rules = AppValidator.getPasswordRules(password);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        children: rules
            .map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        r.satisfied
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 15,
                        color: r.satisfied
                            ? AppConstants.successColor
                            : AppConstants.errorColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        r.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: r.satisfied
                              ? AppConstants.successColor
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AuthController>(
      builder: (_, controller, __) => CustomButton(
        label: 'Create Account',
        icon: Icons.arrow_forward_rounded,
        isLoading: controller.isLoading,
        onPressed: _formValid ? _submit : null,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(AppConstants.routeLogin),
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
