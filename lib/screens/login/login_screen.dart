import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/validators/app_validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _formValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != _formValid) setState(() => _formValid = valid);
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = context.read<AuthController>();
    final success = await controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushReplacementNamed(
        AppConstants.routeDashboard,
        arguments: controller.currentUser,
      );
    } else {
      _showSnack(controller.errorMessage ?? 'Login failed.', isError: true);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildForm(),
              const SizedBox(height: 8),
              _buildRememberRow(),
              const SizedBox(height: 28),
              _buildLoginButton(),
              const SizedBox(height: 28),
              _buildDivider(),
              const SizedBox(height: 24),
              _buildRegisterLink(),
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to access your courses and dashboard.',
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
        children: [
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
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (v) => AppValidator.validateNotEmpty(v, 'Password'),
            onChanged: (_) => _checkFormValidity(),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberRow() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            activeColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            onChanged: (val) => setState(() => _rememberMe = val ?? false),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: const Text(
            'Remember Me',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthController>(
      builder: (_, controller, __) => CustomButton(
        label: 'Sign In',
        icon: Icons.login_rounded,
        isLoading: controller.isLoading,
        onPressed: _formValid ? _login : null,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppConstants.routeRegistration),
            child: const Text(
              'Register',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
