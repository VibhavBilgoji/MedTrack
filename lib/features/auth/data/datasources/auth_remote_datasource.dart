import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

/// Remote data source for Firebase Authentication + Firestore user profile
class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentFirebaseUser => _auth.currentUser;

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );
      return await getUserModel(cred.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), e.code);
    }
  }

  Future<UserModel> signUpWithEmail(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      await cred.user!.updateDisplayName(name);
      final model = UserModel(
        id: cred.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(model.id).set(model.toFirestore());
      return model;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), e.code);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw AuthException('Google sign-in cancelled.');
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(cred);
      final user = userCred.user!;
      final docRef = _firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        final model = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'User',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await docRef.set(model.toFirestore());
        return model;
      }
      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), e.code);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), e.code);
    }
  }

  Future<UserModel> getUserModel(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) return UserModel.fromFirestore(doc);
    final model = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(model.id).set(model.toFirestore());
    return model;
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'email-already-in-use': return 'Email already in use.';
      case 'weak-password': return 'Password is too weak.';
      case 'invalid-email': return 'Invalid email format.';
      case 'user-disabled': return 'This account has been disabled.';
      case 'too-many-requests': return 'Too many attempts. Try again later.';
      default: return 'Authentication error: $code';
    }
  }
}
