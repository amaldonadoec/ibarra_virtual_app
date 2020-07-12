import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:virtual_city_app/src/models/SiteResponse.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  AudioPlayer advancedPlayer;
  String statusAudio = "none";

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    AudioPlayer.logEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    final SiteResponse site = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
        onWillPop: () {
          this.advancedPlayer.stop();

          //trigger leaving and use own data
          Navigator.pop(context, false);

          //we need to return a future
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text('Detalle del sitio'),
              actions: <Widget>[
                _audioControl(site),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: <Widget>[
                    GFCarousel(
                      height: 250,
                      items: site.images.map(
                        (image) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(image.url,
                                  fit: BoxFit.cover, width: 1000.0),
                            ),
                          );
                        },
                      ).toList(),
                      onPageChanged: (index) {},
                    ),
                    GFTypography(
                      text: site.name,
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  site.description ?? '',
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            )))
                  ],
                ))));
  }

  Widget _audioControl(SiteResponse site) {
    return site.audio != null
        ? Container(
            child: Row(
            children: <Widget>[
              this.statusAudio == 'none' || this.statusAudio == 'pause'
                  ? InkWell(
                      child: Icon(
                        Icons.play_arrow,
                        size: 40.00,
                      ),
                      onTap: () {
                        play(site);
                        setState(() {
                          this.statusAudio = 'playing';
                        });
                      },
                    )
                  : Container(),
              this.statusAudio == 'playing'
                  ? InkWell(
                      child: Icon(Icons.pause, size: 40.00),
                      onTap: () {
                        this.advancedPlayer.pause();
                        setState(() {
                          this.statusAudio = 'pause';
                        });
                      },
                    )
                  : Container(),
              this.statusAudio == 'playing'
                  ? InkWell(
                      child: Icon(Icons.stop, size: 40.00),
                      onTap: () {
                        this.advancedPlayer.stop();
                        setState(() {
                          this.statusAudio = 'none';
                        });
                      },
                    )
                  : Container(),
            ],
          ))
        : Container();
  }

  play(SiteResponse site) async {
    int result = await this.advancedPlayer.play(site.audio.url);
    if (result == 1) {
      // success
    }
  }
}
