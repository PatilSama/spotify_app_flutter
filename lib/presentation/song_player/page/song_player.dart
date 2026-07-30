import 'package:flutter/material.dart';
import 'package:spotify_app/common/helpers/hieght_width.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/core/configs/constants/app_url.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

class SongPlayer extends StatelessWidget {
  final SongEntity songEntity;

  const SongPlayer({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text("Now Playing", style: TextStyle(fontSize: 18)),
        action: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
        child: Column(children: [_songCover(context)]),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Hero(
      tag: songEntity.imageName.toString(),
      child: Container(
        height: context.exHeight / 2,
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(30) ,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
      
              '${AppUrl.firestorage}${songEntity.imageName}${AppUrl.mediaAlt}',
            ),
          ),
        ),
      ),
    );
  }

  Widget _songDetail(){
    return Row();
  }
}
