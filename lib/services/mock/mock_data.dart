import '../../models/user.dart';
import '../../models/job.dart';
import '../../models/api.dart';

class MockData {
  // Mock Users - Test Accounts
  static final Map<String, User> mockUsers = {
    'customer1': User(
      id: 'customer-1',
      email: 'customer@test.com',
      name: 'John Doe',
      phone: '+1-555-0101',
      role: UserRole.customer,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    'customer2': User(
      id: 'customer-2',
      email: 'jane@test.com',
      name: 'Jane Smith',
      phone: '+1-555-0102',
      role: UserRole.customer,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    'shoveler1': User(
      id: 'shoveler-1',
      email: 'mike@scoop.com',
      name: 'Mike Shoveler',
      phone: '+1-555-0201',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    'shoveler2': User(
      id: 'shoveler-2',
      email: 'sarah@scoop.com',
      name: 'Sarah Snow',
      phone: '+1-555-0202',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    'shoveler3': User(
      id: 'shoveler-3',
      email: 'tom@scoop.com',
      name: 'Tom Plow',
      phone: '+1-555-0203',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  };

  // Mock Shoveler Profiles
  static final Map<String, ShovelerProfile> mockShovelerProfiles = {
    'shoveler-1': ShovelerProfile(
      id: 'shoveler-1',
      email: 'mike@scoop.com',
      name: 'Mike Shoveler',
      phone: '+1-555-0201',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      rating: 4.8,
      totalJobs: 127,
      boundary: {
        'type': 'Polygon',
        'coordinates': [[
          [-74.010, 40.710],
          [-73.980, 40.710],
          [-73.980, 40.740],
          [-74.010, 40.740],
          [-74.010, 40.710],
        ]],
      },
      onTimeReliability: 94.5,
    ),
    'shoveler-2': ShovelerProfile(
      id: 'shoveler-2',
      email: 'sarah@scoop.com',
      name: 'Sarah Snow',
      phone: '+1-555-0202',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      rating: 4.9,
      totalJobs: 89,
      boundary: {
        'type': 'Polygon',
        'coordinates': [[
          [-74.000, 40.750],
          [-73.970, 40.750],
          [-73.970, 40.780],
          [-74.000, 40.780],
          [-74.000, 40.750],
        ]],
      },
      onTimeReliability: 97.2,
    ),
    'shoveler-3': ShovelerProfile(
      id: 'shoveler-3',
      email: 'tom@scoop.com',
      name: 'Tom Plow',
      phone: '+1-555-0203',
      role: UserRole.shoveler,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      rating: 4.6,
      totalJobs: 34,
      boundary: {
        'type': 'Polygon',
        'coordinates': [[
          [-73.990, 40.760],
          [-73.960, 40.760],
          [-73.960, 40.790],
          [-73.990, 40.790],
          [-73.990, 40.760],
        ]],
      },
      onTimeReliability: 91.8,
    ),
  };

  static List<Job> getMockJobs() {
    final now = DateTime.now();
    return [
      // Pending jobs - awaiting shoveler
      Job(
        id: 'job-1',
        customerId: 'customer-1',
        title: 'Clear driveway and sidewalk',
        description: 'Need driveway and front sidewalk cleared. Heavy snow expected.',
        address: '123 Main St, Manhattan, NY 10001',
        location: LocationCoordinates(lat: 40.7128, lng: -74.0060),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Snowy+Driveway',
        status: JobStatus.pending,
        deadline: now.add(const Duration(days: 1)),
        paymentAmount: 50.00,
        paymentStatus: PaymentStatus.pending,
        aiVerificationStatus: null,
        aiConfidenceScore: null,
        createdAt: now.subtract(const Duration(hours: 2)),
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Doe',
          phone: '+1-555-0101',
        ),
      ),
      Job(
        id: 'job-2',
        customerId: 'customer-2',
        title: 'Parking lot snow removal',
        description: 'Small commercial parking lot (20 spaces). Need it cleared ASAP.',
        address: '456 Oak Avenue, Brooklyn, NY 11201',
        location: LocationCoordinates(lat: 40.6890, lng: -73.9590),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Snowy+Parking+Lot',
        status: JobStatus.pending,
        deadline: now.add(const Duration(hours: 8)),
        paymentAmount: 85.00,
        paymentStatus: PaymentStatus.pending,
        aiVerificationStatus: null,
        aiConfidenceScore: null,
        createdAt: now.subtract(const Duration(minutes: 30)),
        customer: CustomerInfo(
          id: 'customer-2',
          name: 'Jane Smith',
          phone: '+1-555-0102',
        ),
      ),

      // Accepted jobs - shoveler is on the way
      Job(
        id: 'job-3',
        customerId: 'customer-1',
        shovelerId: 'shoveler-1',
        title: 'Front yard snow removal',
        description: 'Front yard and entrance need clearing. Working from home.',
        address: '789 Pine Street, Manhattan, NY 10003',
        location: LocationCoordinates(lat: 40.7282, lng: -73.9942),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Yard',
        status: JobStatus.accepted,
        deadline: now.add(const Duration(hours: 4)),
        paymentAmount: 45.00,
        paymentStatus: PaymentStatus.escrowed,
        aiVerificationStatus: null,
        aiConfidenceScore: null,
        createdAt: now.subtract(const Duration(minutes: 15)),
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Doe',
          phone: '+1-555-0101',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-1',
          name: 'Mike Shoveler',
          rating: 4.8,
        ),
      ),

      // Completed but not verified - awaiting AI verification
      Job(
        id: 'job-4',
        customerId: 'customer-1',
        shovelerId: 'shoveler-2',
        title: 'Driveway and steps',
        description: 'Complete driveway plus front steps and walkway',
        address: '321 Elm Street, Manhattan, NY 10009',
        location: LocationCoordinates(lat: 40.7217, lng: -73.9833),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Elm',
        afterPhotoUrl: 'https://via.placeholder.com/400x300?text=After+Elm',
        status: JobStatus.completed,
        deadline: now.subtract(const Duration(hours: 1)),
        paymentAmount: 65.00,
        paymentStatus: PaymentStatus.escrowed,
        aiVerificationStatus: AIVerificationStatus.pending,
        aiConfidenceScore: null,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        completedAt: now.subtract(const Duration(minutes: 45)),
        verifiedAt: null,
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Doe',
          phone: '+1-555-0101',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-2',
          name: 'Sarah Snow',
          rating: 4.9,
        ),
      ),

      // Verified jobs - payment released
      Job(
        id: 'job-5',
        customerId: 'customer-2',
        shovelerId: 'shoveler-1',
        title: 'Clear parking lot',
        description: 'Small parking lot (15 spaces) cleared completely',
        address: '654 Oak Plaza, Brooklyn, NY 11215',
        location: LocationCoordinates(lat: 40.6514, lng: -73.9776),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Lot',
        afterPhotoUrl: 'https://via.placeholder.com/400x300?text=After+Lot',
        status: JobStatus.verified,
        deadline: now.subtract(const Duration(hours: 3)),
        paymentAmount: 75.00,
        paymentStatus: PaymentStatus.released,
        aiVerificationStatus: AIVerificationStatus.approved,
        aiConfidenceScore: 96.5,
        createdAt: now.subtract(const Duration(days: 3, hours: 2)),
        completedAt: now.subtract(const Duration(days: 2, hours: 6)),
        verifiedAt: now.subtract(const Duration(days: 2, hours: 5)),
        customer: CustomerInfo(
          id: 'customer-2',
          name: 'Jane Smith',
          phone: '+1-555-0102',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-1',
          name: 'Mike Shoveler',
          rating: 4.8,
        ),
      ),

      Job(
        id: 'job-6',
        customerId: 'customer-1',
        shovelerId: 'shoveler-3',
        title: 'Residential driveway',
        description: 'Standard residential driveway, approximately 20x20 ft',
        address: '987 Birch Avenue, Manhattan, NY 10025',
        location: LocationCoordinates(lat: 40.8075, lng: -73.9626),
        beforePhotoUrl: 'https://via.placeholder.com/400x300?text=Before+Birch',
        afterPhotoUrl: 'https://via.placeholder.com/400x300?text=After+Birch',
        status: JobStatus.verified,
        deadline: now.subtract(const Duration(days: 5)),
        paymentAmount: 55.00,
        paymentStatus: PaymentStatus.released,
        aiVerificationStatus: AIVerificationStatus.approved,
        aiConfidenceScore: 94.2,
        createdAt: now.subtract(const Duration(days: 6, hours: 3)),
        completedAt: now.subtract(const Duration(days: 5, hours: 8)),
        verifiedAt: now.subtract(const Duration(days: 5, hours: 7)),
        customer: CustomerInfo(
          id: 'customer-1',
          name: 'John Doe',
          phone: '+1-555-0101',
        ),
        shoveler: ShovelerInfo(
          id: 'shoveler-3',
          name: 'Tom Plow',
          rating: 4.6,
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
        totalJobs: 127,
        distance: 1.2,
        estimatedArrival: 15,
      ),
      ShovelerInfoResponse(
        id: 'shoveler-2',
        name: 'Sarah Snow',
        rating: 4.9,
        totalJobs: 89,
        distance: 2.5,
        estimatedArrival: 25,
      ),
      ShovelerInfoResponse(
        id: 'shoveler-3',
        name: 'Tom Plow',
        rating: 4.6,
        totalJobs: 34,
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
          [-74.010, 40.710],
          [-73.980, 40.710],
          [-73.980, 40.740],
          [-74.010, 40.740],
          [-74.010, 40.710],
        ],
      ],
    };
  }

  // Get mock user profile by ID
  static ShovelerProfile? getShovelerProfile(String shovelerId) {
    return mockShovelerProfiles[shovelerId];
  }
}

