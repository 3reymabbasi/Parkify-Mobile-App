import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackViewModel extends ChangeNotifier {
  final FeedbackService _feedbackService = FeedbackService();

  final List<String> categories = const [
    'App Experience',
    'Parking Lot Quality',
    'Payment Process',
    'Customer Support',
  ];

  String _selectedCategory = 'App Experience';
  int _rating = 0;
  bool _submitted = false;
  bool _loading = false;

  final List<FeedbackModel> _submittedFeedback = [];

  String get selectedCategory => _selectedCategory;
  int get rating => _rating;
  bool get submitted => _submitted;
  bool get canSubmit => _rating > 0;
  bool get loading => _loading;
  List<FeedbackModel> get history => _submittedFeedback;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  Future<bool> submitFeedback(String comment) async {
    if (_rating == 0) return false;

    _loading = true;
    notifyListeners();

    final success = await _feedbackService.submitFeedback(
      category: _selectedCategory,
      rating: _rating,
      comment: comment,
    );

    if (success) {
      _submittedFeedback.add(
        FeedbackModel(
          category: _selectedCategory,
          rating: _rating,
          comment: comment,
          createdAt: DateTime.now(),
        ),
      );
      _submitted = true;
    }

    _loading = false;
    notifyListeners();
    return success;
  }

  void reset() {
    _selectedCategory = 'App Experience';
    _rating = 0;
    _submitted = false;
    notifyListeners();
  }
}
