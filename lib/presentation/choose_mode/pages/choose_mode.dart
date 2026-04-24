import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/core/configs/assets/app_vector.dart';

class ChooseModePage extends StatefulWidget {
  const ChooseModePage({super.key});

  @override
  State<ChooseModePage> createState() => _ChooseModePageState();
}

class _ChooseModePageState extends State<ChooseModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.chooseModeBG),
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(.15)),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(AppVector.logo),
              ),
              Spacer(),
              Text("Choose Mode",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
            ],),
          )
        ],
      ),
    );
  }
}
