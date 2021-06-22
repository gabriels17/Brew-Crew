import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on Firebase User
  AppUser? _userFromFirebaseUser(User? firebaseUser) {
    return AppUser(uid: firebaseUser?.uid);
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = cred.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = cred.user;

      // Create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData('New crew member', '0', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
