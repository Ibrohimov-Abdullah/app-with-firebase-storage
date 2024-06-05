import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/storage_service.dart';
import '../useful widgets/Utils.dart';

class AudiosPage extends StatefulWidget {
  const AudiosPage({super.key});

  @override
  State<AudiosPage> createState() => _AudiosPageState();
}

class _AudiosPageState extends State<AudiosPage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allLIst = ([], []);
  List<String> nameList = [];
  bool loading = false;



  // refresh
  refresh(bool value) {
    setState(() {
      loading = value;
    });
  }

  /// picking a file from device
  Future<File?> takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  /// upload
  Future<void> uploadFile() async {
    refresh(false);
    file = await takeFile();
    Utils.fireSnackBar2("Uploading audio please wait...", context);
    String link = await StorageService.upload(path: "Audios", file: file!);
    log(link);
    await getDate();
    refresh(true);
    Utils.fireSnackBar("Successfully uploaded", context);
  }

  /// read
  Future<void> getDate() async {
    refresh(false);
    allLIst = await StorageService.getDate(path: "Audios");
    linkList = allLIst.$1;
    nameList = allLIst.$2;
    refresh(true);
  }

  /// delete
  Future<void> delete(String url) async {
    refresh(false);
    await StorageService.delete(url);
    await getDate();
  }

  @override
  void initState() {
    super.initState();
    getDate();

  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  final player = AudioPlayer();
  bool isPlaying = true;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  Future<void> playAudio(String url)async{
    await player.play(UrlSource(url));
    player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    player.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
        child: linkList.isNotEmpty ? ListView.builder(
          itemCount: linkList.length,
          itemBuilder: (context, index) => Card(
            color: Colors.blueAccent,
            elevation: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 5),
            child: ListTile(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context) => Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(min: 0,max: duration.inSeconds.toDouble(),value: position.inSeconds.toDouble(), onChanged: (value) {}),
                      const SizedBox(height: 20,),
                      Center(
                        child: MaterialButton(
                          onPressed: ()async{
                            if(isPlaying){
                              await player.pause();
                            }else{
                              await player.play(UrlSource(linkList[index]));
                            }
                            isPlaying = !isPlaying;
                            setState(() {

                            });
                          },
                          minWidth: 50,
                          height: 50,
                          shape: const CircleBorder(),
                          child: isPlaying ? const Icon(Icons.play_arrow_sharp,size: 30,) : const Icon(Icons.pause,size: 30,),
                        ),
                      )
                    ],
                  ),
                ));
              },
              onLongPress: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 150,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                            "Are you sure to delete it ?"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  delete(linkList[index]);
                                  Navigator.pop(context);
                                },
                                child: const Text("delete")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No thanks")),
                          ],
                        ),
                      ],
                    ),
                  )),
              leading: nameList[index].endsWith(".png") || nameList[index].endsWith(".jpg") ? CircleAvatar( radius: 30, backgroundImage: NetworkImage(linkList[index]), ) : Image.network("https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/volume-circle-blue-512.png"),
              title: Text(nameList[index],style: const TextStyle(fontSize: 13),),
            ),
          ),
        ) : const Text("There is no date uploaded yet ! \n\n                         :(", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/lotties/loading_animation.json",
                width: 450, height: 500),
            const Text(
              "Loading...",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: ()async{
          await uploadFile();
        },
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
        child: const Icon(Icons.music_note_outlined),
      ) 
    );
  }
}
