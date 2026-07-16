import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

class FeedbackViewModel extends ChangeNotifier {
  final List<String> categories = const [
    'App Experience',
    'Parking Lot Quality',
    'Payment Process',
    'Customer Support',
  ];

  String _selectedCategory = 'App Experience';
  int _rating = 0;
  bool _submitted = false;

  final List<FeedbackModel> _submittedFeedback = [];

  String get selectedCategory => _selectedCategory;
  int get rating => _rating;
  bool get submitted => _submitted;
  bool get canSubmit => _rating > 0;
  List<FeedbackModel> get history => _submittedFeedback;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  void submitFeedback(String comment) {
    _submittedFeedback.add(
      FeedbackModel(
        category: _selectedCategory,
        rating: _rating,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
    _submitted = true;
    notifyListeners();
  }

  void reset() {
    _selectedCategory = 'App Experience';
    _rating = 0;
    _submitted = false;
    notifyListeners();
  }
}
