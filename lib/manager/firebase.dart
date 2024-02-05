import 'package:firebase_auth/firebase_auth.dart';
import 'package:herogame_case/models/user_credentials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isSignedIn => auth.currentUser != null;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required CredentialModel credential,
  }) async {
    final register = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore
        .collection('users')
        .doc(register.user!.uid)
        .set(credential.toMap());
  }

  Future<void> updateProfile(CredentialModel credential) async {
    await _firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update(credential.toMap());
  }

  Future<CredentialModel> getProfile() async {
    final DocumentSnapshot<Map<String, dynamic>> user =
        await _firestore.collection('users').doc(auth.currentUser!.uid).get();
    return CredentialModel.fromMap(user.data()!);
  }
}
