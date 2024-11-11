import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom exception for auth errors
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, [this.code]);

  @override
  String toString() => message;
}

// Response model for login
class AuthResponse {
  final User user;
  final String role;
  final String? error;

  AuthResponse({
    required this.user,
    required this.role,
    this.error,
  });
}

// Main authentication service
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  Future<AuthResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('Email and password cannot be empty');
      }

      if (!_isValidEmail(email)) {
        throw AuthException('Invalid email format');
      }

      // Attempt to sign in
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw AuthException('Login failed - no user returned');
      }

      // Fetch user role from Firestore
      final role = await _getUserRole(user.uid);

      return AuthResponse(user: user, role: role);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseErrorMessage(e.code), e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Failed to logout: ${e.toString()}');
    }
  }

  // Get user role from Firestore
  Future<String> _getUserRole(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        throw AuthException('User profile not found');
      }

      final role = docSnapshot.get('role') as String?;
      if (role == null || role.isEmpty) {
        throw AuthException('User role not defined');
      }

      return role;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to fetch user role: ${e.toString()}');
    }
  }

  // Helper method to validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Helper method to get readable error messages
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later';
      default:
        return 'An error occurred during login';
    }
  }

  // Check if user has required role
  Future<bool> hasRole(String requiredRole) async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final userRole = await _getUserRole(user.uid);
      return userRole == requiredRole;
    } catch (e) {
      return false;
    }
  }
}