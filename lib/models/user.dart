enum UserRole {
  customer,
  shoveler,
}

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ShovelerProfile extends User {
  final double rating;
  final int totalJobs;
  final Map<String, dynamic>? boundary;
  final double? onTimeReliability;

  ShovelerProfile({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    required super.role,
    required super.createdAt,
    required this.rating,
    required this.totalJobs,
    this.boundary,
    this.onTimeReliability,
  });

  factory ShovelerProfile.fromJson(Map<String, dynamic> json) {
    return ShovelerProfile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: UserRole.shoveler,
      createdAt: DateTime.parse(json['createdAt']),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalJobs: json['totalJobs'] ?? 0,
      boundary: json['boundary'],
      onTimeReliability: json['onTimeReliability']?.toDouble(),
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final double? rating;
  final int? totalJobs;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.rating,
    this.totalJobs,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.customer,
      ),
      rating: json['rating']?.toDouble(),
      totalJobs: json['totalJobs'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString().split('.').last,
      'rating': rating,
      'totalJobs': totalJobs,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class RegisterData {
  final String name;
  final String email;
  final String password;
  final String phone;
  final UserRole role;

  RegisterData({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role.toString().split('.').last,
    };
  }
}

class LoginData {
  final String email;
  final String password;

  LoginData({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UpdateProfileData {
  final String? name;
  final String? phone;

  UpdateProfileData({
    this.name,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (phone != null) map['phone'] = phone;
    return map;
  }
}

