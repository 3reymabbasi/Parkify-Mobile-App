// ============================================================
//  SmartParkify — UserService
//  Firebase Firestore se user profile manage karo
//  Get profile, Update profile, Admin: manage users
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── GET CURRENT USER PROFILE ───────────────────────────────
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── REAL-TIME USER PROFILE STREAM ─────────────────────────
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    return _db.collection('users').doc(_uid).snapshots().map((doc) {
      if (doc.exists) return doc.data();
      return null;
    });
  }

  // ── UPDATE PROFILE ─────────────────────────────────────────
  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      await _db.collection('users').doc(_uid).update({
        'name': name,
        'phone': phone,
        'initials': _getInitials(name),
      });

      // Firebase Auth display name bhi update karo
      await _auth.currentUser!.updateDisplayName(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── ADMIN: GET ALL USERS ───────────────────────────────────
  Stream<List<UserModel>> getAllUsersStream() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'user')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return UserModel.fromMap({...data, 'uid': doc.id});
          }).toList(),
        );
  }

  // ── ADMIN: SUSPEND USER ────────────────────────────────────
  Future<bool> suspendUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'status': 'suspended'});
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── ADMIN: ACTIVATE USER ───────────────────────────────────
  Future<bool> activateUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'status': 'active'});
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── ADMIN: DELETE USER ─────────────────────────────────────
  Future<bool> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Helper ─────────────────────────────────────────────────
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }
}
