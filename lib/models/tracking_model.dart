enum TrackingStatus { completed, current, pending }

class TrackingStageModel {
  final String title;
  final String timeAndDesc;
  final TrackingStatus status;
  final bool hasProof;
  final String? proofImageUrl;

  TrackingStageModel({
    required this.title,
    required this.timeAndDesc,
    required this.status,
    this.hasProof = false,
    this.proofImageUrl,
  });
}
