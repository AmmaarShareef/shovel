import 'constants.dart';

class Validators {
  static bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static bool validatePhone(String phone) {
    final phoneRegex = RegExp(r'^[\d\s\-\+\(\)]+$');
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    return phoneRegex.hasMatch(phone) && digitsOnly.length >= 10;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }
    return null;
  }

  static String? validateDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'Description is required';
    }
    if (description.length > AppConstants.maxDescriptionLength) {
      return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';
    }
    return null;
  }

  static String? validateDeadline(DateTime? deadline) {
    if (deadline == null) {
      return 'Deadline is required';
    }
    final now = DateTime.now();
    if (deadline.isBefore(now) || deadline.isAtSameMomentAs(now)) {
      return 'Deadline must be in the future';
    }
    return null;
  }

  static String? validatePaymentAmount(double? amount) {
    if (amount == null || amount <= 0) {
      return 'Payment amount must be greater than 0';
    }
    if (amount > 10000) {
      return 'Payment amount cannot exceed \$10,000';
    }
    return null;
  }
}

