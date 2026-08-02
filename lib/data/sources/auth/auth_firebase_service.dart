import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/core/configs/constants/app_url.dart';
import 'package:spotify_app/data/models/auth/create_user_req.dart';
import 'package:spotify_app/data/models/auth/signin_user_req.dart';
import 'package:spotify_app/data/models/auth/user_model.dart';
import 'package:spotify_app/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signInUserReq);

  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> getUser();
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

  @override
  Future<Either<dynamic, dynamic>> getUser() async {
    try{
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).get();
      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageUrl = firebaseAuth.currentUser?.photoURL ?? AppUrl.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return right(userEntity);
    }catch (error){
      return left("An Error Occurred.");
    }
  }
}
