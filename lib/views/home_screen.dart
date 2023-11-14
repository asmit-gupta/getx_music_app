import 'package:flutter/material.dart';
import 'package:getx_music_app/viewmodel/controller/player_controller.dart';
import 'package:getx_music_app/constant/colors.dart';
import 'package:getx_music_app/constant/text_style.dart';
import 'package:get/get.dart';
import 'package:getx_music_app/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var audiocontroller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: whiteColor,
              ))
        ],
        title: Text(
          "Music",
          style: ourStyle(
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audiocontroller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No songs found!',
                style: ourStyle(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: Obx(
                      () => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        tileColor: bgColor,
                        title: Text(
                          snapshot.data![index].title,
                          style: ourStyle(
                            size: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data![index].artist,
                          style: ourStyle(
                            size: 12,
                          ),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        trailing: audiocontroller.playIndex.value == index &&
                                audiocontroller.isPlaying.value
                            ? const Icon(
                                Icons.play_arrow,
                                color: whiteColor,
                                size: 26,
                              )
                            : null,
                        onTap: () {
                          Get.to(
                            () => Player(
                              data: snapshot.data!,
                            ),
                            transition: Transition.downToUp,
                          );
                          audiocontroller.playSong(
                              snapshot.data![index].uri, index);
                        },
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
