import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> initializeAuth() async {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .orderBy('email')
          .get();

      return userSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'email': data['email'] ?? '',
          'role': data['role'] ?? 'user',
          'createdAt': data['createdAt'] ?? '',
          'lastLogin': data['lastLogin'] ?? '',
          'isActive': data['isActive'] ?? true,
        };
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<void> updateLastLogin(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  Future<void> assignUserRole(String email, String newRole) async {
    try {
      final QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found');
      }

      await userQuery.docs.first.reference.update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': _auth.currentUser?.email,
      });
    } catch (e) {
      print('Error assigning user role: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      final QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found');
      }

      // Soft delete by marking user as inactive
      await userQuery.docs.first.reference.update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
        'deletedBy': _auth.currentUser?.email,
      });
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}