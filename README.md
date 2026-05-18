# EduAuth — Flutter Multi-Screen Authentication App

A complete multi-screen Flutter application built for the **Mobile App Development** assignment.  
It demonstrates user authentication, form validation, clean architecture, and navigation.

---

## Student Information

| Field | Value |
|-------|-------|
| **Student Name** | *(Replace with your name)* |
| **Student ID** | *(Replace with your ID)* |
| **Course** | Mobile App Development |
| **Framework** | Flutter / Dart |

---

## Project Structure

```
lib/
├── main.dart                          # App entry, routing, theme
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Colors, routes, subject data
│   ├── enums/
│   │   ├── gender_enum.dart           # Gender enum with display names
│   │   └── auth_state_enum.dart       # AuthState enum
│   └── validators/
│       └── app_validator.dart         # Reusable validator class
├── models/
│   ├── user_model.dart                # User data model + serialisation
│   └── subject_model.dart            # Subject data model
├── controllers/
│   └── auth_controller.dart          # Business logic (ChangeNotifier)
├── widgets/
│   ├── custom_text_field.dart        # Reusable text field component
│   └── custom_button.dart            # Reusable button component
└── screens/
    ├── registration/
    │   └── registration_screen.dart
    ├── login/
    │   └── login_screen.dart
    ├── dashboard/
    │   └── dashboard_screen.dart
    └── detail/
        └── detail_screen.dart
```

---

## Features

### Authentication Flow
- **Registration** → **Login** → **Dashboard** → **Detail**
- Session persistence via `shared_preferences` with *Remember Me* toggle
- Automatic session restoration on app launch

### Registration Screen
- First name, last name, email, gender (dropdown), password, confirm password
- Real-time password rule checklist (6+ chars, uppercase, special character)
- Submit button disabled until all fields are valid
- Success dialog navigating to Login on completion

### Login Screen
- Email + password with full validation
- Show/hide password toggle (eye icon)
- Remember Me checkbox persists session across restarts
- Error feedback via SnackBar

### Dashboard Screen
- User avatar (initials), full name, email displayed in hero app bar
- Credit count stats chip
- Tappable subject cards (Mobile App Development, Software Re-engineering, MIS)
- Logout with confirmation dialog

### Detail Screen
- Subject name, code, emoji icon in gradient hero header
- Course overview description
- Schedule, room, instructor, credit hours displayed in info rows
- Learning outcomes section

---

## Architecture

| Concern | Implementation |
|---------|---------------|
| Business logic | `AuthController` (ChangeNotifier) |
| State management | Provider (`ChangeNotifierProvider`) |
| Validation | `AppValidator` static class |
| Categorical values | `Gender` and `AuthState` enums |
| Persistence | `shared_preferences` |
| UI components | `CustomTextField`, `CustomButton` |

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Installation

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd flutter_auth_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management |
| `shared_preferences` | ^2.3.2 | Local session persistence |

---

## Screens

> *(Replace the placeholder text below with actual screenshots after running the app)*

| Splash | Registration | Login |
|--------|-------------|-------|
| ![Splash](screenshots/splash.png) | ![Registration](screenshots/registration.png) | ![Login](screenshots/login.png) |

| Dashboard | Detail |
|-----------|--------|
| ![Dashboard](screenshots/dashboard.png) | ![Detail](screenshots/detail.png) |

---

## Validator Class Reference

```dart
AppValidator.validateEmail(value)           // Email format check
AppValidator.validatePassword(value)        // 6+ chars, uppercase, special char
AppValidator.validateConfirmPassword(v, pw) // Match check
AppValidator.validateName(value, fieldName) // Non-empty, 2+ chars, letters only
AppValidator.validateNotEmpty(value, name)  // Generic required-field check
AppValidator.getPasswordRules(value)        // Returns List<PasswordRule> for live checklist
```

---

## Enum Reference

```dart
// Gender
Gender.male | .female | .other | .preferNotToSay
gender.displayName  // → "Male", "Female", etc.
Gender.fromString("Male")  // → Gender.male

// AuthState
AuthState.initial | .loading | .authenticated | .unauthenticated | .registrationSuccess | .error
authState.isLoading        // bool convenience getter
authState.isAuthenticated  // bool convenience getter
```

---

## License

This project is submitted for academic evaluation only.
