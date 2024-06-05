import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

@immutable
class StorageService{
  static final storage = FirebaseStorage.instance;

  // upload
  static Future<String> upload({required String path, required File file}) async {

    Reference reference = storage.ref(path).child("${DateTime.now().toLocal().toIso8601String()}${file.path.substring(file.path.lastIndexOf("."))}");

    log(file.path.substring(file.path.lastIndexOf(".")).toString());
    log("${DateTime.now().toIso8601String()}_${file.path.substring(file.path.lastIndexOf("."))}");
    log(DateTime.now().toLocal().toString());

    UploadTask task = reference.putFile(file);
    await task.whenComplete(() {});

    return reference.getDownloadURL();
  }

  // read
  static Future<(List<String>, List<String>)> getDate({required String path})async{
    List<String> listLinks= [];
    List<String> listNames = [];
    final Reference reference = storage.ref(path);
    final ListResult list = await reference.listAll();
    for (var e in list.items) {
      listLinks.add(await e.getDownloadURL());
      listNames.add(e.name);
    }

    return (listLinks,listNames);
  }

  // delete
  static Future<void> delete(String url)async{
    final Reference reference = storage.refFromURL(url);
    await reference.delete();
  }

}