import 'package:dartz/dartz.dart';
import 'package:spotify_app/data/sources/song/song_firebase_service.dart';
import 'package:spotify_app/domain/repository/song/song.dart';
import 'package:spotify_app/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either<dynamic, dynamic>> getPlayList() async {
    return await sl<SongFirebaseService>().getPlayList();
  }
}
