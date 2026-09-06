import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user != null) {
      await createUserDoc(credential.user!);
    }
    return credential;
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user != null) {
      await createUserDoc(credential.user!);
    }
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> beginPhoneAuth({
    required String phoneNumber,
    required void Function(String verificationId, int? forceResendingToken)
        codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(AuthCredential credential) verificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await createUserDoc(userCredential.user!);
        }
        verificationCompleted(credential);
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp(
      String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      await createUserDoc(userCredential.user!);
    }
    return userCredential;
  }

  Future<void> createUserDoc(User user) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final doc = await userDocRef.get();

    if (doc.exists) {
      // User document already exists (with the correct UID as ID)
      return;
    }

    final email = user.email?.toLowerCase().trim() ?? '';

    // Step 1: Check if an approved pre-provisioned staff record exists by email
    if (email.isNotEmpty) {
      final preProvisionedQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('is_pre_provisioned', isEqualTo: true)
          .limit(1)
          .get();

      if (preProvisionedQuery.docs.isNotEmpty) {
        final preDoc = preProvisionedQuery.docs.first;
        final preData = preDoc.data();

        // Approved pre-provisioned staff record exists: activate approved role!
        await userDocRef.set({
          ...preData,
          'uid': user.uid,
          'photo_url': user.photoURL ?? preData['photo_url'] ?? '',
          'is_pre_provisioned': false,
          'updated_time': FieldValue.serverTimestamp(),
        });

        if (preDoc.id != user.uid) {
          await preDoc.reference.delete();
        }
        return;
      }
    }

    // Step 2: No approved staff record exists -> assign unprivileged 'Student' role.
    // Unknown/unapproved accounts are denied staff access.
    await userDocRef.set({
      'email': email,
      'display_name': user.displayName ?? '',
      'photo_url': user.photoURL ?? '',
      'uid': user.uid,
      'created_time': FieldValue.serverTimestamp(),
      'role': 'Student',
      'notifications_enabled': true,
    });
  }

  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}
