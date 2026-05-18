/// Reusable validator class — all UI-independent validation logic lives here.
class AppValidator {
  AppValidator._(); // prevent instantiation

  // ─── Email ───────────────────────────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ─── Password ─────────────────────────────────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!value.contains(RegExp(r"""[!@#$%^&*(),.?":{}|<>\-_=+\[\]\\;'`~/]"""))) {
  return 'Password must contain at least 1 special character';
}
    return null;
  }

  /// Returns a list of rule descriptors and whether each is satisfied.
  static List<PasswordRule> getPasswordRules(String value) {
    return [
      PasswordRule(
        label: 'At least 6 characters',
        satisfied: value.length >= 6,
      ),
      PasswordRule(
        label: 'At least 1 uppercase letter',
        satisfied: value.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRule(
  label: 'At least 1 special character',
  satisfied: value.contains(
      RegExp(r"""[!@#$%^&*(),.?":{}|<>\-_=+\[\]\\;'`~/]""")),
),
    ];
  }

  // ─── Confirm Password ─────────────────────────────────────────────────────
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ─── Generic non-empty ────────────────────────────────────────────────────
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ─── Name ─────────────────────────────────────────────────────────────────
  static String? validateName(String? value, String fieldName) {
    final emptyError = validateNotEmpty(value, fieldName);
    if (emptyError != null) return emptyError;
    if (value!.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  // ─── Gender ───────────────────────────────────────────────────────────────
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a gender';
    }
    return null;
  }
}

class PasswordRule {
  final String label;
  final bool satisfied;

  const PasswordRule({required this.label, required this.satisfied});
}
