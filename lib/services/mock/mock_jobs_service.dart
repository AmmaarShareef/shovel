import 'dart:async';
import '../../models/job.dart';
import 'mock_data.dart';

import '../../services/api/jobs_service.dart';

class MockJobsService implements IJobsService {
  List<Job> _jobs = MockData.getMockJobs();

  Future<void> _delay([int ms = 1000]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<Job> createJob(CreateJobData data) async {
    await _delay(1500);

    final newJob = Job(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      customerId: 'customer-1',
      title: data.title,
      description: data.description,
      address: data.address,
      location: data.location,
      beforePhotoUrl: data.beforePhoto,
      status: JobStatus.pending,
      deadline: data.deadline,
      paymentAmount: 50.00,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
    );

    _jobs.insert(0, newJob);
    return newJob;
  }

  @override
  Future<List<Job>> getJobs({JobFilters? filters}) async {
    await _delay(800);

    var filtered = List<Job>.from(_jobs);

    if (filters?.status != null) {
      filtered = filtered.where((job) => job.status == filters!.status).toList();
    }

    return filtered;
  }

  @override
  Future<Job> getJob(String jobId) async {
    await _delay(500);

    final job = _jobs.firstWhere(
      (j) => j.id == jobId,
      orElse: () => throw Exception('Job not found'),
    );
    return job;
  }

  @override
  Future<List<Job>> getAvailableJobs(double lat, double lng, {double? radius}) async {
    await _delay(800);
    return _jobs.where((job) => job.status == JobStatus.pending).toList();
  }

  @override
  Future<Job> acceptJob(String jobId) async {
    await _delay(1000);

    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) throw Exception('Job not found');

    final job = _jobs[index];
    final updatedJob = Job(
      id: job.id,
      customerId: job.customerId,
      shovelerId: 'shoveler-1',
      title: job.title,
      description: job.description,
      address: job.address,
      location: job.location,
      beforePhotoUrl: job.beforePhotoUrl,
      status: JobStatus.accepted,
      deadline: job.deadline,
      paymentAmount: job.paymentAmount,
      paymentStatus: PaymentStatus.escrowed,
      createdAt: job.createdAt,
      customer: job.customer,
      shoveler: ShovelerInfo(
        id: 'shoveler-1',
        name: 'Mike Shoveler',
        rating: 4.8,
      ),
    );

    _jobs[index] = updatedJob;
    return updatedJob;
  }

  @override
  Future<Job> completeJob(String jobId, String afterPhoto) async {
    await _delay(1500);

    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) throw Exception('Job not found');

    final job = _jobs[index];
    final updatedJob = Job(
      id: job.id,
      customerId: job.customerId,
      shovelerId: job.shovelerId,
      title: job.title,
      description: job.description,
      address: job.address,
      location: job.location,
      beforePhotoUrl: job.beforePhotoUrl,
      afterPhotoUrl: afterPhoto,
      status: JobStatus.completed,
      deadline: job.deadline,
      paymentAmount: job.paymentAmount,
      paymentStatus: job.paymentStatus,
      createdAt: job.createdAt,
      completedAt: DateTime.now(),
      customer: job.customer,
      shoveler: job.shoveler,
    );

    _jobs[index] = updatedJob;

    // Simulate AI verification after delay
    Future.delayed(const Duration(seconds: 2), () {
      final verifiedJob = Job(
        id: updatedJob.id,
        customerId: updatedJob.customerId,
        shovelerId: updatedJob.shovelerId,
        title: updatedJob.title,
        description: updatedJob.description,
        address: updatedJob.address,
        location: updatedJob.location,
        beforePhotoUrl: updatedJob.beforePhotoUrl,
        afterPhotoUrl: updatedJob.afterPhotoUrl,
        status: JobStatus.verified,
        deadline: updatedJob.deadline,
        paymentAmount: updatedJob.paymentAmount,
        paymentStatus: PaymentStatus.released,
        aiVerificationStatus: AIVerificationStatus.approved,
        aiConfidenceScore: 0.95,
        createdAt: updatedJob.createdAt,
        completedAt: updatedJob.completedAt,
        verifiedAt: DateTime.now(),
        customer: updatedJob.customer,
        shoveler: updatedJob.shoveler,
      );
      final verifyIndex = _jobs.indexWhere((j) => j.id == jobId);
      if (verifyIndex != -1) {
        _jobs[verifyIndex] = verifiedJob;
      }
    });

    return updatedJob;
  }

  @override
  Future<Job> getJobStatus(String jobId) async {
    return getJob(jobId);
  }

  @override
  Future<void> submitRating(String jobId, RatingData rating) async {
    await _delay(800);
    // Mock - just log
    print('Rating submitted: $jobId - ${rating.rating}');
  }
}

