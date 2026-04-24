import 'package:flutter/material.dart';
import 'package:spotify_app/presentation/intro/pages/get_started.dart';

class SplashService {

  Future<void> redirect(BuildContext context)async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> GetStarted()));
  }
}