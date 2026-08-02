import 'package:dartz/dartz.dart';
import 'package:spotify_app/core/usecase/usecase.dart';
import 'package:spotify_app/domain/repository/auth/auth.dart';
import 'package:spotify_app/service_locator.dart';

class GetUserUseCase extends UseCase<Either,dynamic>{
  @override
  Future<Either<dynamic, dynamic>> call({params}) async {

    return await sl<AuthRepository>().getUser();
  }

}