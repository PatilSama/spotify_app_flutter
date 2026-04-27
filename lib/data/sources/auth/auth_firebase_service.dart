import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/data/models/auth/create_user_req.dart';

abstract class AuthFirebaseService {
  Future<void> signin();

  Future<void> signup(CreateUserReq createUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<void> signin() {
    throw UnimplementedError();
  }

  @override
  Future<void> signup(CreateUserReq createUseReq) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUseReq.email,
        password: createUseReq.password,
      );
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }
}
