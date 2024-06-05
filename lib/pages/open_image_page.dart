import 'package:flutter/material.dart';

class OpenImagePage extends StatefulWidget {
  const OpenImagePage({super.key, required this.networkImage});
  final String networkImage;
  @override
  State<OpenImagePage> createState() => _OpenImagePageState();

}

class _OpenImagePageState extends State<OpenImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network(widget.networkImage)),
    );
  }
}
