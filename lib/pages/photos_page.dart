import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storage_learning/pages/open_image_page.dart';
import 'package:lottie/lottie.dart';

import '../services/storage_service.dart';
import '../useful widgets/Utils.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allLIst = ([], []);
  List<String> nameList = [];
  bool loading = false;

  DateTime dateTime = DateTime.now();


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
    Utils.fireSnackBar2("Uploading photo please wait...", context);
    String link = await StorageService.upload(path: "Photos", file: file!);
    log(link);
    await getDate();
    refresh(true);
    Utils.fireSnackBar("Successfully uploaded", context);
  }

  /// read
  Future<void> getDate() async {
    refresh(false);
    allLIst = await StorageService.getDate(path: "Photos");
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => OpenImagePage(networkImage: linkList[index])));
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
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await uploadFile();
        },
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
        child: const Icon(Icons.add_photo_alternate_sharp),
      ),
    );
  }
}
