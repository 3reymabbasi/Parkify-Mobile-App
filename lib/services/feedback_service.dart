import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> submitFeedback({
    required String category,
    required int rating,
    required String comment,
  }) async {
    try {
      final uid = _auth.currentUser?.uid ?? '';
      await _db.collection('feedbacks').add({
        'driverId': uid,
        'category': category,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
