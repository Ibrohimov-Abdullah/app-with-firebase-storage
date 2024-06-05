import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storage_learning/pages/audios_page.dart';
import 'package:flutter_storage_learning/pages/files_page.dart';
import 'package:flutter_storage_learning/pages/photos_page.dart';
import 'package:flutter_storage_learning/pages/videos_page.dart';
import 'package:flutter_storage_learning/services/storage_service.dart';
import 'package:flutter_storage_learning/useful%20widgets/Utils.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String appBarName = "Pages";
  final Color _iconColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: ()async{
              await AuthService.logoutAccount();
            }, icon: const Icon(Icons.logout))
          ],
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.video_collection,color: _iconColor),
              child: const Text("Videos",style: TextStyle(fontWeight: FontWeight.w700),),
            ),
            Tab(
              icon: Icon(Icons.collections_bookmark_rounded,color: _iconColor),
              child: const Text("Pdf Files",style: TextStyle(fontWeight: FontWeight.w700),),
            ),
            Tab(
              icon: Icon(Icons.collections_rounded,color: _iconColor),
              child: const Text("Photos",style: TextStyle(fontWeight: FontWeight.w700),),
            ),
            Tab(
              icon: Icon(Icons.my_library_music_rounded,color: _iconColor ),
              child: const Text("Audios",style: TextStyle(fontWeight: FontWeight.w700),),
            ),
          ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
          ),
        ),
        body: TabBarView(
          children: [
            VideosPage(),
            FilesPage(),
            PhotosPage(),
            AudiosPage()
          ],
        )
      ),
    );
  }
}
