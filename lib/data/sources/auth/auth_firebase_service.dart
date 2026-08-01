import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/data/models/auth/create_user_req.dart';
import 'package:spotify_app/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signInUserReq);

  Future<Either> signup(CreateUserReq createUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signInUserReq) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signInUserReq.email,
            password: signInUserReq.password,
          );
      return right("SignIn was Successfull.");
    } on FirebaseAuthException catch (error) {
      String message = "";
      switch (error.code) {
        case "invalid-email":
          message = "Not user found for that email.";
          break;
        case 'invalid-credential':
          message = "Wrong Pass and email provided for that user.";
          break;
      }
      return left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUseReq) async {
    try {
     var data =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUseReq.email,
        password: createUseReq.password,
      );
     FirebaseFirestore.instance.collection('users').doc(data.user?.uid).set({
       'name':createUseReq.fullName,
       'email':data.user?.email
     });
      return right("SignUp was Successfully.");
    } on FirebaseAuthException catch (error) {
      String message = '';
      if (error.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (error.code == "email-already-in-use") {
        message = 'An Account Already exists with that email.';
      }
      return left(message);
    }
  }
}
