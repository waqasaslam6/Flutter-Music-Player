
import 'dart:io';
import 'dart:ui';
import 'package:flute_example/pages/newScreen.dart';
import 'package:flute_example/pages/now_playing.dart';
import 'package:flute_example/widgets/mp_circle_avatar.dart';
import 'package:flute_example/widgets/mp_inherited.dart';
import 'package:flutter/material.dart';
import 'package:flute_example/data/song_data.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flute_example/main.dart';
import 'package:flute_example/my_app.dart';
import 'root_page.dart';



class PlayListScreen extends StatelessWidget {
  final List<MaterialColor> _colors = Colors.primaries;

  @override

  final fontFamily = "Roboto";

  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);
    SongData songData = rootIW.songData;
    //Goto Now Playing Page
    void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new AudioPlayerWidget(
                rootIW.songData,
                s,
                nowPlayTap: nowPlayTap,
              )));
    }

    //Shuffle Songs and goto now playing page
    void shuffleSongs() {
      goToNowPlaying(rootIW.songData.randomSong);
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Container for playlist header
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text("PLAYLIST", style: TextStyle(color: Colors.grey, fontFamily: fontFamily, fontWeight: FontWeight.w900, letterSpacing: 1),),
                            SizedBox(width: 4,),
                            Text("All Songs", style: TextStyle(color: Colors.grey[900], fontFamily: fontFamily, fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 22),)
                          ],
                        ),

                        //Container for button down button
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 1.0, blurRadius: 8.0)],
                            borderRadius: BorderRadius.all(Radius.circular(50)),

                          ),
                        //  child: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30,),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  //Container for ListView of playlist
                  ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    itemBuilder: (context,int index){
                      var s = songData.songs[index];
                      final MaterialColor color = _colors[index % _colors.length];
                      var artFile =
                      s.albumArt == null ? null : new File.fromUri(Uri.parse(s.albumArt));
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                      ListTile(
                      dense: false,
                      leading: new Hero(
                      child: avatar(artFile, s.title, color),
                      tag: s.title,
                      ),
                      title: new Text(s.title),
                      subtitle: new Text(
                      "By ${s.artist}",
                      style: Theme.of(context).textTheme.caption,
                      ),
                      onTap: () {
                      songData.setCurrentIndex(index);
                      Navigator.push(
                      context,
                      new MaterialPageRoute(
                      builder: (context) => new AudioPlayerWidget(songData, s)));
                      },
                      )
                              ],
                            ),
                          ),

                       //   Text("03:02", style: TextStyle(color: Colors.grey, fontFamily: fontFamily, fontWeight: FontWeight.w900, letterSpacing: 0.5),)
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>Divider(height: 40,),
                    itemCount: songData.songs.length,
                    shrinkWrap: true,
                    controller: ScrollController(keepScrollOffset: false),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          //Container for blue PlayContainer

          Container(
            padding: EdgeInsets.all(32),
            color: Colors.lightBlue,
            width: double.infinity,
            child: Row(
              children: <Widget>[

                SizedBox(width: 32,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text("Music Player by Waqas Aslam",style: TextStyle(
                      fontFamily: fontFamily,
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0
                  ),),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}