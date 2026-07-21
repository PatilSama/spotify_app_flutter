import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_app/data/models/song/song.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    try{
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();

      for(var element in data.docs){
        var songModel = SongModel.fromJson(element.data());
        songs.add(songModel.toEntity());
      }
      return right(songs);
    }catch (error){
      return left("An error occurred, Please try again");
    }
  }
}
