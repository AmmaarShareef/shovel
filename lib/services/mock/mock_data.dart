import '../../models/user.dart';
import '../../models/job.dart';
import '../../models/api.dart';

class MockData {
  static final Map<String, User> mockUsers = {
    'customer1': User(
      id: 'customer-1',
      email: 'customer@example.com',
      name: 'John Customer',
      phone: '+1234567890',
      role: UserRole.customer,
      createdAt: DateTime.now(),
    ),
    'shoveler1': User(
      id: 'shoveler-1',
      email: 'shoveler@example.com',
      name: 'Mike Shoveler',
      phone: '+1234567891',
      role: UserRole.shoveler,
      createdAt: DateTime.now(),
    ),
  };

  static List<Job> getMockJobs() {
    return [
      Job(
        id: 'job-1',
        customerId: 'customer-1',
        title: 'Clear driveway and sidewalk',
        description: 'Need driveway and front sidewalk cleared. Heavy snow expected.',
        address: '123 Main St, New York, NY 10001',
        location: LocationCoordinates(lat: 40.7128, lng: -74.0060),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Photo',
        status: JobStatus.pending,
        deadline: DateTime.now().add(const Duration(days: 1)),
        paymentAmount: 50.00,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
      ),
      Job(
        id: 'job-2',
        customerId: 'customer-1',
        shovelerId: 'shoveler-1',
        title: 'Clear parking lot',
        description: 'Small parking lot needs clearing',
        address: '456 Oak Ave, New York, NY 10002',
        location: LocationCoordinates(lat: 40.7580, lng: -73.9855),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Photo',
        afterPhotoUrl: 'https://via.placeholder.com/400x300?text=After+Photo',
        status: JobStatus.verified,
        deadline: DateTime.now().subtract(const Duration(hours: 2)),
        paymentAmount: 75.00,
        paymentStatus: PaymentStatus.released,
        aiVerificationStatus: AIVerificationStatus.approved,
        aiConfidenceScore: 0.95,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        verifiedAt: DateTime.now().subtract(const Duration(days: 2)),
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Customer',
          phone: '+1234567890',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-1',
          name: 'Mike Shoveler',
          rating: 4.8,
        ),
      ),
      Job(
        id: 'job-3',
        customerId: 'customer-1',
        shovelerId: 'shoveler-1',
        title: 'Front yard snow removal',
        description: 'Front yard needs to be cleared',
        address: '789 Pine St, New York, NY 10003',
        location: LocationCoordinates(lat: 40.7505, lng: -73.9934),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Photo',
        status: JobStatus.accepted,
        deadline: DateTime.now().add(const Duration(hours: 12)),
        paymentAmount: 60.00,
        paymentStatus: PaymentStatus.escrowed,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Customer',
          phone: '+1234567890',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-1',
          name: 'Mike Shoveler',
          rating: 4.8,
        ),
      ),
    ];
  }

  static List<ShovelerInfoResponse> getMockShovelers() {
    return [
      ShovelerInfoResponse(
        id: 'shoveler-1',
        name: 'Mike Shoveler',
        rating: 4.8,
        totalJobs: 45,
        distance: 1.2,
        estimatedArrival: 15,
      ),
      ShovelerInfoResponse(
        id: 'shoveler-2',
        name: 'Sarah Snow',
        rating: 4.9,
        totalJobs: 78,
        distance: 2.5,
        estimatedArrival: 25,
      ),
      ShovelerInfoResponse(
        id: 'shoveler-3',
        name: 'Tom Plow',
        rating: 4.6,
        totalJobs: 32,
        distance: 0.8,
        estimatedArrival: 10,
      ),
    ];
  }

  static Map<String, dynamic> getMockBoundary() {
    return {
      'type': 'Polygon',
      'coordinates': [
        [
          [-74.01, 40.71],
          [-74.00, 40.71],
          [-74.00, 40.72],
          [-74.01, 40.72],
          [-74.01, 40.71],
        ],
      ],
    };
  }
}

