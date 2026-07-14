import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;

      // Update display name
      await user.updateDisplayName(displayName);

      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        photoUrl: '',
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login with email and password
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;

      // Get user from Firestore
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle Firebase auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}