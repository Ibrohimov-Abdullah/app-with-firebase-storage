import 'package:flutter/material.dart';

sealed class Utils{
  static void fireSnackBar(String msg, BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg, style: const TextStyle(fontSize:  16, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
        shape: const StadiumBorder(),
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        behavior: SnackBarBehavior.floating,
      )
    );
  }

  static void fireSnackBar2(String msg, BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade400.withOpacity(0.95),
          content: Text(msg, style: const TextStyle(fontSize:  16, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
          shape: const StadiumBorder(),
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          behavior: SnackBarBehavior.floating,
        )
    );
  }
}