import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        return 'Something went wrong. Try again.';
      }

      final doc = await _db.collection('drivers').doc(uid).get();

      if (doc.exists) {
        final role = doc.data()?['role']?.toString().trim() ?? 'driver';
        return role;
      }

      return 'driver';
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return 'Something went wrong. Try again.';
    }
  }

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

      await credential.user!.updateDisplayName(name);

      await _db.collection('drivers').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email.trim(),
        'phone': phone,
        'gender': gender,
        'role': 'driver',
        'status': 'active',
        'bookings': 0,
        'spent': '0',
        'joined': DateTime.now().toIso8601String(),
        'lastBooking': '',
        'initials': _getInitials(name),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return 'Registration failed. Please try again.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    }
  }

  Future<bool> isManager(String uid) async {
    try {
      final doc = await _db.collection('drivers').doc(uid).get();
      return doc.data()?['role'] == 'manager';
    } catch (e) {
      return false;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }

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
      case 'invalid-credential':
        return 'Incorrect email or password.';
      default:
        return 'Authentication error. Please try again.';
    }
  }
}
