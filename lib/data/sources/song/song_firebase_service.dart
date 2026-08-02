import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:spotify_app/data/models/song/song.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify_app/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();

  Future<Either> getPlayList();

  Future<Either> addOrRemoveFavoriteSongs(String songId);

  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
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
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
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
    List<SongEntity> songs = [];
    try {
      var data = await FirebaseFirestore.instance
          .collection("songs")
          .orderBy('releasedate', descending: true)
          .get();

      for (var element in data.docs) {

        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
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

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {

    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;
      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection("users")
          .doc(uId)
          .collection("favorite")
          .where("songId", isEqualTo: songId)
          .get();
      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('users')
            .doc(uId)
            .collection('favorite')
            .add({'songId': songId, 'addedDate': Timestamp.now()});
        isFavorite = true;
      }
      return right(isFavorite);
    } catch (error) {
      return left("An Error Occurred");
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    String uId = user!.uid;
    try {
      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('users')
          .doc(uId)
          .collection('favorite')
          .where('songId', isEqualTo: songId)
          .get();
      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getUserFavoriteSongs() async{
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    String uId = user!.uid;
    List<SongEntity> favoriteSongs = [];
    try {
      QuerySnapshot favoriteSnapshot = await firebaseFirestore
          .collection('users')
          .doc(uId)
          .collection('favorite')
          .get();

      for(var element in favoriteSnapshot.docs){
        String songId = element['songId'];
        var song = await firebaseFirestore.collection('songs').doc(songId).get();
        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(songModel.toEntity());
      }
      return right(favoriteSongs);
    } catch (error) {
      return left(error);
    }
  }
}
