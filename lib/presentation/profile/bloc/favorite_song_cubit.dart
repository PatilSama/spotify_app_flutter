import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/domain/usecases/song/get_favorite_song.dart';
import 'package:spotify_app/presentation/profile/bloc/favorite_song_state.dart';
import 'package:spotify_app/service_locator.dart';

class FavoriteSongCubit extends Cubit<FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongLoading());

  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSong() async {
    var result = await sl<GetFavoriteSongUseCase>().call();
    result.fold(
      (error) {
        emit(FavoriteSongFailure());
      },
      (favoriteSongs) {
        this.favoriteSongs = favoriteSongs;
        emit(FavoriteSongLoaded(favoriteSongs: this.favoriteSongs));
      },
    );
  }
  void removeSong(int index){
    favoriteSongs.removeAt(index);
    emit(FavoriteSongLoaded(favoriteSongs: favoriteSongs));
  }
}
