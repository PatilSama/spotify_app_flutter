import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_app/data/models/song/song.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();

  Future<Either> getPlayList();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either<dynamic, dynamic>> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('songs')
          .orderBy('releasedate', descending: true)
          .limit(3)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        songs.add(songModel.toEntity());
      }
      return right(songs);
    } catch (error) {
      if (kDebugMode) {
        print("Firebase Error = ${error.toString()}");
      }
      return left("An error occurred, Please try again");
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getPlayList() async {
    List<SongEntity> songs= [];
    try {
      var data = await FirebaseFirestore.instance
          .collection("songs")
          .orderBy('releasedate', descending: true)
          .get();


      for(var element in data.docs){
        var songModel = SongModel.fromJson(element.data());
        songs.add(songModel.toEntity());
      }
      // final jsnList = data.docs.map((ele) => ele.data()).toList();
      // List<SongEntity> songs = await compute(returnInObject, jsnList);
      return right(songs);
    } catch (error) {
      print("Error $error");
      return left("An error occurred, Please try again");
    }
  }

  Future<List<SongEntity>> returnInObject(
    List<Map<String, dynamic>> data,
  ) async {
    // List<SongEntity> songs = [];
    // for (var element in data) {
    //   var songModel = SongModel.fromJson(element);
    //   songs.add(songModel.toEntity());
    // }
    List<SongEntity> songs = data.map((element) {
      return SongModel.fromJson(element).toEntity();
    }).toList();
    return songs;
  }
}
