// ============================================================
//  SmartParkify — AuthService
//  Firebase Authentication ke sare operations yahan hain
//  Login, Register, Logout, Password Reset
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Current logged-in user ─────────────────────────────────
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── LOGIN ──────────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check karo yeh admin hai ya normal user
      final doc = await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (doc.exists) {
        return doc.data()?['role'] ?? 'user';
      }
      return 'user';
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return 'Something went wrong. Try again.';
    }
  }

  // ── REGISTER ───────────────────────────────────────────────
  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String gender,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      await credential.user!.updateDisplayName(name);

      // Firestore mein user document banao
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email.trim(),
        'phone': phone,
        'gender': gender,
        'role': 'user', // default role
        'status': 'active',
        'bookings': 0,
        'spent': '0',
        'joined': DateTime.now().toIso8601String(),
        'lastBooking': '',
        'initials': _getInitials(name),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // null = success (koi error nahi)
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return 'Registration failed. Please try again.';
    }
  }

  // ── LOGOUT ─────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── PASSWORD RESET ─────────────────────────────────────────
  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    }
  }

  // ── Check admin credentials (Admin login ke liye) ──────────
  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  // ── Helper: initials nikalo name se ───────────────────────
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }

  // ── Helper: Firebase error codes ko readable banao ─────────
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Authentication error. Please try again.';
    }
  }
}
