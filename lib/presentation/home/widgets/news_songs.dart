import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/home/bloc/news_song_cubit.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return NewsSongCubit();
      },
      child: SizedBox(height: 200,
        child: BlocBuilder<NewsSongCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongSLoading) {
              return Container(alignment:Alignment.center,child: CircularProgressIndicator());
            } else if (state is NewsSongsFailure) {
              return Center(child: Text(""),);
            } else if (state is NewsSongsLoaded) {
              return _songs(state.songs);
            }
            return Text("Something went wrong.");
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(children: [],);
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 14);
        },
        itemCount: songs.length);
  }
}
