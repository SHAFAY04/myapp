enum Gender {
  male,
  female,
  other,
  preferNotToSay;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      case Gender.preferNotToSay:
        return 'Prefer Not To Say';
    }
  }

  static Gender? fromString(String value) {
    for (final gender in Gender.values) {
      if (gender.displayName == value) return gender;
    }
    return null;
  }
}
