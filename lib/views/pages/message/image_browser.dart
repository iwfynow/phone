import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageBrowser extends StatelessWidget {
  final Uint8List imagePath;
  final DateTime timeStamp;
  final String fullName;
  const ImageBrowser({super.key, required this.imagePath, required this.timeStamp, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(fullName),
          subtitle: Text(DateFormat('MMM, d :h:mm a').format(timeStamp)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InteractiveViewer(
        panEnabled: true,
        boundaryMargin: const EdgeInsets.all(0),
        minScale: 0.1,
        maxScale: 3.0,
        child: Center(
          child: Image.memory(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}