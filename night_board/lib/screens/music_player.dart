import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayerState musicPlayerState = AudioPlayerState.PAUSED;
  AudioCache musicCache;
  String path = 'Baby_Steps.mp3';

  @override
  void initState(){
    super.initState();
    musicCache = AudioCache(fixedPlayer: musicPlayer);
    musicPlayer.onPlayerStateChanged.listen((AudioPlayerState s){
      setState(() {
        musicPlayerState = s;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    musicPlayer.release();
    musicPlayer.dispose();
    musicCache.clearCache();
  }

  @override
  playMusic() async {
    await musicCache.play(path);
  }

  @override
  pauseMusic() async{
    await musicPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
