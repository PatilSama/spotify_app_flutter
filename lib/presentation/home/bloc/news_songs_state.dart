import 'package:spotify_app/domain/entities/song/song.dart';

abstract class NewsSongsState {}

class NewsSongSLoading extends NewsSongsState {}

class NewsSongsLoaded extends NewsSongsState {
  final List<SongEntity> songs;

  NewsSongsLoaded({required this.songs});
}

class NewsSongsFailure extends NewsSongsState{}
