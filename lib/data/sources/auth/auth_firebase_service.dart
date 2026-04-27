import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/data/models/auth/create_user_req.dart';
import 'package:spotify_app/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signinUserReq);

  Future<Either> signup(CreateUserReq createUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);
      return right("Signin was Successful");
    } on FirebaseAuthException catch (e) {
      String message = '';
      if(e.code == 'invalid-email'){
        message = "Not User found for that email";
      }else if(e.code == 'invalid-credential'){
        message = "Wrong password provided for that user";
      }
      return left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUseReq) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUseReq.email,
        password: createUseReq.password,
      );
      return Right("SignUp was Successful");
    } on FirebaseAuthException catch (error) {
      String message = '';
      if (error.code == 'weak-password') {
        message = "The password provider is too weak";
      } else if (error.code == 'email-already-in-use') {
        message = "An account already exists with that email";
      }


      return left(message);
    }
  }
}
