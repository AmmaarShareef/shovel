import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../services/api/disputes_service.dart';

class DisputeProvider with ChangeNotifier {
  List<Dispute> _userDisputes = [];
  List<Dispute> _activeDisputes = [];
  Dispute? _activeDispute;
  bool _isLoading = false;
  String? _error;

  List<Dispute> get userDisputes => _userDisputes;
  List<Dispute> get activeDisputes => _activeDisputes;
  Dispute? get activeDispute => _activeDispute;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fileDispute({
    required String jobId,
    required String filledBy,
    required String reason,
    String? evidenceUrl,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final dispute = await disputesService.fileDispute(
        jobId: jobId,
        filledBy: filledBy,
        reason: reason,
        evidenceUrl: evidenceUrl,
      );
      _userDisputes.insert(0, dispute);
      _activeDispute = dispute;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserDisputes({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userDisputes = await disputesService.getUserDisputes(status: status);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActiveDisputes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _activeDisputes = await disputesService.getActiveDisputes();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDispute(String disputeId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final dispute = await disputesService.getDispute(disputeId);
      _activeDispute = dispute;
      final index = _userDisputes.indexWhere((d) => d.id == disputeId);
      if (index != -1) {
        _userDisputes[index] = dispute;
      } else {
        _userDisputes.insert(0, dispute);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitJuryVote({
    required String disputeId,
    required String voteType,
    String? comment,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await disputesService.submitJuryVote(
        disputeId: disputeId,
        voteType: voteType,
        comment: comment,
      );

      // Refresh the dispute
      await fetchDispute(disputeId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveDispute(Dispute? dispute) {
    _activeDispute = dispute;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
