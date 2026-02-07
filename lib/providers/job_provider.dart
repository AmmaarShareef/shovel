import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../services/api/jobs_service.dart';

class JobProvider with ChangeNotifier {
  List<Job> _jobs = [];
  Job? _activeJob;
  bool _isLoading = false;
  String? _error;

  List<Job> get jobs => _jobs;
  Job? get activeJob => _activeJob;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createJob(CreateJobData data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final job = await jobsService.createJob(data);
      _jobs.insert(0, job);
      _activeJob = job;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedJob = await jobsService.acceptJob(jobId);
      final index = _jobs.indexWhere((j) => j.id == jobId);
      if (index != -1) {
        _jobs[index] = updatedJob;
      }
      if (_activeJob?.id == jobId) {
        _activeJob = updatedJob;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeJob(String jobId, String afterPhoto) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedJob = await jobsService.completeJob(jobId, afterPhoto);
      final index = _jobs.indexWhere((j) => j.id == jobId);
      if (index != -1) {
        _jobs[index] = updatedJob;
      }
      if (_activeJob?.id == jobId) {
        _activeJob = updatedJob;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJobs({JobFilters? filters}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _jobs = await jobsService.getJobs(filters: filters);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJob(String jobId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final job = await jobsService.getJob(jobId);
      _activeJob = job;
      final index = _jobs.indexWhere((j) => j.id == jobId);
      if (index != -1) {
        _jobs[index] = job;
      } else {
        _jobs.insert(0, job);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitRating(String jobId, RatingData rating) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await jobsService.submitRating(jobId, rating);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveJob(Job? job) {
    _activeJob = job;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

