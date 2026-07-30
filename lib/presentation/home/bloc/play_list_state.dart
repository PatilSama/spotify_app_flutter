import 'package:spotify_app/domain/entities/song/song.dart';

abstract class PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  List<SongEntity> songs = [];

  PlayListLoaded({required this.songs});
}

class PlayListLoadFailure extends PlayListState {
  String massage;
  PlayListLoadFailure({required this.massage});
}
