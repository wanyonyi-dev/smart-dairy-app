import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_dairy/screens/dashboard_screen.dart';
import 'package:smart_dairy/screens/login_screen.dart';
import 'package:smart_dairy/screens/register_screen.dart' as register_screen;
import 'package:smart_dairy/screens/splash_screen.dart';
import 'package:smart_dairy/dashboards/worker_dashboard.dart' as worker_dashboard;
import 'package:smart_dairy/dashboards/vet_dashboard.dart' as vet_dashboard;
import 'package:smart_dairy/dashboards/admin_dashboard.dart' as admin_dashboard;

// User Management Service
class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final UserManagementService _instance = UserManagementService._internal();

  factory UserManagementService() {
    return _instance;
  }

  UserManagementService._internal();

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize auth settings
  Future<void> initializeAuth() async {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  // Get current user role
  Future<String?> getCurrentUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  // Update last login
  Future<void> updateLastLogin() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating last login: $e');
    }
  }
}

// Auth Route Guard
class AuthGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const AuthGuard({
    Key? key,
    required this.child,
    required this.allowedRoles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: UserManagementService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const SizedBox.shrink();
        }

        return FutureBuilder<String?>(
          future: UserManagementService().getCurrentUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!roleSnapshot.hasData || !allowedRoles.contains(roleSnapshot.data)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
              return const SizedBox.shrink();
            }

            return child;
          },
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBgtQUC7OTkS0cLgvZhwbl-e-n2qgDzxbA",
      appId: "1:414168279150:web:43eac949716a810ad41e7f",
      authDomain: "smart-dairy-65e22.firebaseapp.com",
      messagingSenderId: "414168279150",
      storageBucket: "smart-dairy-65e22.appspot.com",
      projectId: "smart-dairy-65e22",
    ),
  );

  // Initialize user management service
  final userService = UserManagementService();
  await userService.initializeAuth();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const register_screen.RegisterScreen(),
        "/dashboard": (context) => AuthGuard(
          allowedRoles: ['Farm Owner'],
          child: const DashboardScreen(),
        ),
        '/admin': (context) => AuthGuard(
          allowedRoles: ['admin'],
          child: const admin_dashboard.AdminDashboard(),
        ),
        '/worker': (context) => AuthGuard(
          allowedRoles: ['Farm Worker'],
          child: const worker_dashboard.WorkerDashboard(),
        ),
        '/vet': (context) => AuthGuard(
          allowedRoles: ['Veterinarian'],
          child: const vet_dashboard.VetDashboard(),
        ),
      },
    );
  }
}

// Your existing services...
class RealtimeDatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> saveMilkRecord(String category, String description, double amount) async {
    await _db.child('milkRecords').push().set({
      'category': category,
      'description': description,
      'amount': amount,
      'timestamp': ServerValue.timestamp,
      'userId': FirebaseAuth.instance.currentUser?.uid, // Add user ID
    });
  }

  Future<void> saveFinancialRecord(String category, String description, double amount) async {
    await _db.child('financialRecords').push().set({
      'category': category,
      'description': description,
      'amount': amount,
      'timestamp': ServerValue.timestamp,
      'userId': FirebaseAuth.instance.currentUser?.uid, // Add user ID
    });
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOtherRecord(String category, String description, double amount) async {
    await _firestore.collection('otherRecords').add({
      'category': category,
      'description': description,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid, // Add user ID
    });
  }
}