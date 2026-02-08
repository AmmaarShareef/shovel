import '../../models/job.dart';
import '../../utils/config.dart';
import 'api_client.dart';
import '../mock/mock_jobs_service.dart';

abstract class IJobsService {
  Future<Job> createJob(CreateJobData data);
  Future<List<Job>> getJobs({JobFilters? filters});
  Future<Job> getJob(String jobId);
  Future<List<Job>> getAvailableJobs(double lat, double lng, {double? radius});
  Future<Job> acceptJob(String jobId);
  Future<Job> completeJob(String jobId, String afterPhoto);
  Future<Job> verifyJob(String jobId);
  Future<Job> getJobStatus(String jobId);
  Future<void> submitRating(String jobId, RatingData rating);
}

class RealJobsService implements IJobsService {
  @override
  Future<Job> createJob(CreateJobData data) async {
    final response = await ApiClient.post<Map<String, dynamic>>(
      '/jobs',
      data: data.toJson(),
    );
    return Job.fromJson(response);
  }

  @override
  Future<List<Job>> getJobs({JobFilters? filters}) async {
    final response = await ApiClient.get<List<dynamic>>(
      '/jobs',
      queryParameters: filters?.toJson(),
    );
    return response.map((json) => Job.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<Job> getJob(String jobId) async {
    final response = await ApiClient.get<Map<String, dynamic>>('/jobs/$jobId');
    return Job.fromJson(response);
  }

  @override
  Future<List<Job>> getAvailableJobs(double lat, double lng, {double? radius}) async {
    final params = {'lat': lat, 'lng': lng};
    if (radius != null) params['radius'] = radius;
    
    final response = await ApiClient.get<List<dynamic>>(
      '/jobs/available',
      queryParameters: params,
    );
    return response.map((json) => Job.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<Job> acceptJob(String jobId) async {
    final response = await ApiClient.post<Map<String, dynamic>>('/jobs/$jobId/accept');
    return Job.fromJson(response);
  }

  @override
  Future<Job> completeJob(String jobId, String afterPhoto) async {
    final response = await ApiClient.post<Map<String, dynamic>>(
      '/jobs/$jobId/complete',
      data: {'afterPhoto': afterPhoto},
    );
    return Job.fromJson(response);
  }

  @override
  Future<Job> verifyJob(String jobId) async {
    final response = await ApiClient.post<Map<String, dynamic>>(
      '/jobs/$jobId/verify',
    );
    return Job.fromJson(response);
  }

  @override
  Future<Job> getJobStatus(String jobId) async {
    final response = await ApiClient.get<Map<String, dynamic>>('/jobs/$jobId/status');
    return Job.fromJson(response);
  }

  @override
  Future<void> submitRating(String jobId, RatingData rating) async {
    await ApiClient.post('/jobs/$jobId/rating', data: rating.toJson());
  }
}

final IJobsService jobsService = useMockServices
    ? MockJobsService()
    : RealJobsService();

