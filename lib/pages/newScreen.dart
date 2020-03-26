import 'package:flute_example/my_app.dart';
import 'package:flute_example/pages/now_playing.dart';
import 'package:flute_example/widgets/mp_control_button.dart';
import 'package:flute_example/widgets/mp_inherited.dart';
import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flute_example/data/song_data.dart';
import 'dart:async';
import 'dart:ui';

import 'PlayListScreen.dart';

enum PlayerState { stopped, playing, paused }
class AudioPlayerWidget extends StatefulWidget {

  final Song _song;
  final SongData songData;
  final bool nowPlayTap;
  AudioPlayerWidget(this.songData, this._song, {this.nowPlayTap});
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  MusicFinder audioPlayer;
  Duration duration;
  Duration position;
  PlayerState playerState;
  Song song;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  @override
  initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
    play(widget.songData.nextSong);
  }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = widget.songData.audioPlayer;
    }
    setState(() {
      song = widget._song;
      if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
        if (playerState != PlayerState.stopped) {
          stop();
        }
      }
      play(song);
      //  else {
      //   widget._song;
      //   playerState = PlayerState.playing;
      // }
    });
    audioPlayer.setDurationHandler((d) => setState(() {
      duration = d;
    }));

    audioPlayer.setPositionHandler((p) => setState(() {
      position = p;
    }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play(Song s) async {
    if (s != null) {
      final result = await audioPlayer.play(s.uri, isLocal: true);
      if (result == 1)
        setState(() {
          playerState = PlayerState.playing;
          song = s;
        });
    }
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future next(SongData s) async {
    stop();
    setState(() {
      play(s.nextSong);
    });
  }

  Future prev(SongData s) async {
    stop();
    play(s.prevSong);
  }

  Future mute(bool muted) async {
    final result = await audioPlayer.mute(muted);
    if (result == 1)
      setState(() {
        isMuted = muted;
      });
  }
  final fontFamily= "Roboto";


  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);
   return Scaffold(
      body: Column(
        children: <Widget>[
          //Container for header

          Container(
            width: double.infinity,

            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //Container for image
                Container(
                    margin: EdgeInsets.only(left: 32, right: 32),
                    width: double.infinity,
                    child: ClipRRect(
                      child: Image.asset("assets/images/mubin.jpeg", fit: BoxFit.contain,height: MediaQuery.of(context).size.height-260,),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(200), bottomRight: Radius.circular(200)),
                    )
                ),

                //Container for audio player
                Positioned(
                  child: Container(
                    width: 300,
                    height: 80,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 10.0, spreadRadius: 0.1)]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.fast_rewind, color: Colors.grey[700], size: 30,),
//                        ),
//                        IconButton(
//                          icon: Icon(Icons.play_arrow, color: Colors.grey[700], size: 30,),
//                        ),
//                        IconButton(
//                          icon: Icon(Icons.fast_forward, color: Colors.grey[700], size: 30,),
//                        )
                        new ControlButton(Icons.skip_previous, () => prev(widget.songData)),
                        new ControlButton(isPlaying ? Icons.pause : Icons.play_arrow,
                            isPlaying ? () => pause() : () => play(widget._song)),
                        new ControlButton(Icons.skip_next, () => next(widget.songData)),
                      ],
                    ),
                  ),
                  bottom: 5,
                )
              ],
            ),
          ),

          //Container for playlist header

          SizedBox(height: 10,),

          Container(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("SONGS", style: TextStyle(color: Colors.grey, fontFamily: fontFamily, fontWeight: FontWeight.w900, letterSpacing: 1),),
                    SizedBox(height: 3,),
                    Text("ALL SONGS", style: TextStyle(color: Colors.grey[900], fontFamily: fontFamily, fontWeight: FontWeight.w700, letterSpacing: 1, fontSize: 22),),
                  ],
                ),

                //Container For down Button
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 1.0, blurRadius: 8.0)]
                  ),
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[900], size: 30,),
                    onPressed: (){

                      //code to navigate to different screen
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyApp()
                      ));
                    },
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 10,),

          //Container for Icons

          Container(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.redAccent,),
                ),
                IconButton(
                  icon: Icon(Icons.repeat, color: Colors.grey[700],),
                ),
                IconButton(
                  icon: Icon(Icons.shuffle, color: Colors.grey[700]),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey[700],),
                ),
              ],
            ),
          ),

     SizedBox(height: 10,),

          //Container for song name
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline,
                ),
                new Text(
                  song.artist,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),


          //Container for player indicator,
          duration == null
              ? new Container()
              : new Slider(
              value: position?.inMilliseconds?.toDouble() ?? 0,
              onChanged: (double value) =>
                  audioPlayer.seek((value / 1000).roundToDouble()),
              min: 0.0,
              max: duration.inMilliseconds.toDouble()),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            new Text(
                position != null
                    ? "${positionText ?? ''} / ${durationText ?? ''}"
                    : duration != null ? durationText : '',
                // ignore: conflicting_dart_import
                style: new TextStyle(fontSize: 18.0))
          ]),

        ],
      ),
    );
  }



}