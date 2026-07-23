import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/core/configs/constants/app_url.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/home/bloc/news_song_cubit.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return NewsSongCubit()..getNewsSongs();
      },
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongSLoading) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else if (state is NewsSongsFailure) {
              return Center(child: Text("No Result"));
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
    return SizedBox(
      height: 160,

      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          var url = '${AppUrl.firestorage}${songs[index].imageName}${AppUrl.mediaAlt}';
          return Column(
            children: [
              Expanded(
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                    image:  DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${AppUrl.firestorage}${songs[index].imageName}${AppUrl.mediaAlt}',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
