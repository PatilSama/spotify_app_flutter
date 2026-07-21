import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/usecases/song/get_news_songs.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_state.dart';
import 'package:spotify_app/service_locator.dart';

class NewsSongCubit extends Cubit<NewsSongsState> {
  NewsSongCubit():super(NewsSongSLoading());

  Future<void> getNewsSongs() async {

    var returnedSongs =await sl<GetNewsSongsUseCase>().call();
    returnedSongs.fold((l){
      emit(NewsSongsFailure());
    }, (data){
      emit(NewsSongsLoaded(songs: data));
    });
  }
}
