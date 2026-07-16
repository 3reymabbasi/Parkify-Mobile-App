class FeedbackModel {
  final String category;
  final int rating;
  final String comment;
  final DateTime createdAt;

  FeedbackModel({
    required this.category,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
