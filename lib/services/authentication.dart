import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp( email,  password , nickname);

  Future getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }
  Future<String> signUp( email, password, nickname) async {
    FirebaseUser usercurrent = await FirebaseAuth.instance.currentUser();
    final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    databaseReference.reference().child('users').push().set({
      'userUID' : user.uid,
      'name': nickname,
      'email': email,
      'password' : password
    });
  //   UserUpdateInfo updateInfo = UserUpdateInfo();
  // updateInfo.displayName = nickname;
  // user.updateProfile(updateInfo);
  // // await user.reload();
  //  print('USERNAME IS: ${user.displayName}');
    return user.uid;
  }

  Future getCurrentUser() async {
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    print(user.uid);
//    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}
