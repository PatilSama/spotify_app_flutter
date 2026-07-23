import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

class SongModel {
  String? imageName;
  String? title;
  String? artist;
  num? duration;
  Timestamp? releasedate;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releasedate,
    required this.imageName
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releasedate = data['releasedate'];
    imageName = data['imageName'];
  }
}

extension SongModelx on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      imageName: imageName,
      title: title,
      artist: artist,
      duration: duration,
      releasedate: releasedate,
    );
  }
}
