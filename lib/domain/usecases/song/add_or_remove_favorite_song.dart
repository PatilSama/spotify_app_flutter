import 'package:dartz/dartz.dart';
import 'package:spotify_app/core/usecase/usecase.dart';
import 'package:spotify_app/domain/repository/song/song.dart';
import 'package:spotify_app/service_locator.dart';

class AddOrRemoveFavoriteSongUseCase extends UseCase<Either, String> {
  @override
  Future<Either<dynamic, dynamic>> call({String? params}) async{
    return await sl<SongRepository>().addOrRemoveFavoriteSongs(params!);
  }
}
