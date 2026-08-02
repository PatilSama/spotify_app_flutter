import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_app/core/configs/constants/app_url.dart';
import 'package:spotify_app/presentation/profile/bloc/favorite_song_cubit.dart';
import 'package:spotify_app/presentation/profile/bloc/favorite_song_state.dart';
import 'package:spotify_app/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify_app/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify_app/presentation/song_player/page/song_player.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xff2C2B2B),
      ),
      body: SizedBox(
        child: Column(
          children: [
            _profileInfo(context),
            const SizedBox(height: 30),
            _favoriteSongs(),
          ],
        ),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) =>
      FavoriteSongCubit()
        ..getFavoriteSong(),
      child: Column(
        children: [
          Text("FAVORITE SONGS"),
          BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
            builder: (context, state) {
              if (state is FavoriteSongLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is FavoriteSongFailure) {
                return Center(child: Text("Try Again"));
              } else if (state is FavoriteSongLoaded) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                SongPlayer(
                                songEntity: state.favoriteSongs[index])));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(AppUrl.defaultImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    state.favoriteSongs[index].title!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    state.favoriteSongs[index].artist!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                state.favoriteSongs[index].duration
                                    .toString()
                                    .replaceAll('.', ':'),
                              ),
                              SizedBox(width: 20),
                              FavoriteButton(
                                key: UniqueKey(),
                                songEntity: state.favoriteSongs[index],
                                function: () {
                                  context.read<FavoriteSongCubit>().removeSong(
                                    index,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 20),
                  itemCount: state.favoriteSongs.length,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      ProfileInfoCubit()
        ..getUser(),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(state.userEntity.imageUrl!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(state.userEntity.email!),
                  const SizedBox(height: 10),
                  Text(
                    state.userEntity.fullName!,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else if (state is ProfileInfoFailure) {
              return Text("Please try again.");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
