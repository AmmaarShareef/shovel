import '../../models/job.dart';
import 'api_client.dart';

class DisputesService {
  static const String _endpoint = '/disputes';

  /// File a dispute for a job
  Future<Dispute> fileDispute({
    required String jobId,
    required String filledBy,
    required String reason,
    String? evidenceUrl,
  }) async {
    final response = await ApiClient.post(
      '$_endpoint',
      data: {
        'jobId': jobId,
        'filledBy': filledBy,
        'reason': reason,
        'evidence': evidenceUrl,
      },
    );

    return Dispute.fromJson(response.data);
  }

  /// Get dispute details
  Future<Dispute> getDispute(String disputeId) async {
    final response = await ApiClient.get('$_endpoint/$disputeId');
    return Dispute.fromJson(response.data);
  }

  /// Get all disputes for a user
  Future<List<Dispute>> getUserDisputes({
    String? status,
    int? limit,
    int? offset,
  }) async {
    final params = {
      if (status != null) 'status': status,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    final response = await ApiClient.get(
      '$_endpoint/user',
      queryParameters: params,
    );

    final List<dynamic> data = response.data;
    return data.map((item) => Dispute.fromJson(item)).toList();
  }

  /// Submit jury vote on a dispute
  Future<void> submitJuryVote({
    required String disputeId,
    required String voteType,
    String? comment,
  }) async {
    await ApiClient.post(
      '$_endpoint/$disputeId/vote',
      data: {
        'voteType': voteType,
        'comment': comment,
      },
    );
  }

  /// Get active disputes requiring jury review
  Future<List<Dispute>> getActiveDisputes({
    int? limit = 10,
  }) async {
    final response = await ApiClient.get(
      '$_endpoint/active',
      queryParameters: {'limit': limit},
    );

    final List<dynamic> data = response.data;
    return data.map((item) => Dispute.fromJson(item)).toList();
  }

  /// Resolve a dispute
  Future<Dispute> resolveDispute({
    required String disputeId,
    required String resolution,
  }) async {
    final response = await ApiClient.post(
      '$_endpoint/$disputeId/resolve',
      data: {'resolution': resolution},
    );

    return Dispute.fromJson(response.data);
  }
}

final DisputesService disputesService = DisputesService();
