enum JobStatus {
  pending,
  accepted,
  completed,
  verified,
  refunded,
}

enum PaymentStatus {
  pending,
  escrowed,
  released,
  refunded,
}

enum AIVerificationStatus {
  approved,
  rejected,
  manualReview,
  pending,
}

class Job {
  final String id;
  final String customerId;
  final String? shovelerId;
  final String title;
  final String description;
  final String address;
  final LocationCoordinates location;
  final String beforePhotoUrl;
  final String? afterPhotoUrl;
  final JobStatus status;
  final DateTime deadline;
  final double paymentAmount;
  final PaymentStatus paymentStatus;
  final AIVerificationStatus? aiVerificationStatus;
  final double? aiConfidenceScore;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? verifiedAt;
  final CustomerInfo? customer;
  final ShovelerInfo? shoveler;

  Job({
    required this.id,
    required this.customerId,
    this.shovelerId,
    required this.title,
    required this.description,
    required this.address,
    required this.location,
    required this.beforePhotoUrl,
    this.afterPhotoUrl,
    required this.status,
    required this.deadline,
    required this.paymentAmount,
    required this.paymentStatus,
    this.aiVerificationStatus,
    this.aiConfidenceScore,
    required this.createdAt,
    this.completedAt,
    this.verifiedAt,
    this.customer,
    this.shoveler,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      customerId: json['customerId'],
      shovelerId: json['shovelerId'],
      title: json['title'],
      description: json['description'],
      address: json['address'],
      location: LocationCoordinates.fromJson(json['location']),
      beforePhotoUrl: json['beforePhotoUrl'],
      afterPhotoUrl: json['afterPhotoUrl'],
      status: JobStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => JobStatus.pending,
      ),
      deadline: DateTime.parse(json['deadline']),
      paymentAmount: (json['paymentAmount'] ?? 0.0).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      aiVerificationStatus: json['aiVerificationStatus'] != null
          ? AIVerificationStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['aiVerificationStatus'],
              orElse: () => AIVerificationStatus.pending,
            )
          : null,
      aiConfidenceScore: json['aiConfidenceScore']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt']) : null,
      customer: json['customer'] != null ? CustomerInfo.fromJson(json['customer']) : null,
      shoveler: json['shoveler'] != null ? ShovelerInfo.fromJson(json['shoveler']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'shovelerId': shovelerId,
      'title': title,
      'description': description,
      'address': address,
      'location': location.toJson(),
      'beforePhotoUrl': beforePhotoUrl,
      'afterPhotoUrl': afterPhotoUrl,
      'status': status.toString().split('.').last,
      'deadline': deadline.toIso8601String(),
      'paymentAmount': paymentAmount,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'aiVerificationStatus': aiVerificationStatus?.toString().split('.').last,
      'aiConfidenceScore': aiConfidenceScore,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'customer': customer?.toJson(),
      'shoveler': shoveler?.toJson(),
    };
  }
}

class LocationCoordinates {
  final double lat;
  final double lng;

  LocationCoordinates({required this.lat, required this.lng});

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
    return LocationCoordinates(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class CustomerInfo {
  final String id;
  final String name;
  final String phone;

  CustomerInfo({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class ShovelerInfo {
  final String id;
  final String name;
  final double rating;

  ShovelerInfo({
    required this.id,
    required this.name,
    required this.rating,
  });

  factory ShovelerInfo.fromJson(Map<String, dynamic> json) {
    return ShovelerInfo(
      id: json['id'],
      name: json['name'],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
    };
  }
}

class CreateJobData {
  final String title;
  final String description;
  final String address;
  final LocationCoordinates location;
  final DateTime deadline;
  final String beforePhoto;

  CreateJobData({
    required this.title,
    required this.description,
    required this.address,
    required this.location,
    required this.deadline,
    required this.beforePhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'location': location.toJson(),
      'deadline': deadline.toIso8601String(),
      'beforePhoto': beforePhoto,
    };
  }
}

class JobFilters {
  final JobStatus? status;
  final double? lat;
  final double? lng;
  final double? radius;
  final double? minPayment;
  final double? maxPayment;

  JobFilters({
    this.status,
    this.lat,
    this.lng,
    this.radius,
    this.minPayment,
    this.maxPayment,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status.toString().split('.').last;
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (radius != null) map['radius'] = radius;
    if (minPayment != null) map['minPayment'] = minPayment;
    if (maxPayment != null) map['maxPayment'] = maxPayment;
    return map;
  }
}

class RatingData {
  final int rating;
  final String? comment;

  RatingData({
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }
}
