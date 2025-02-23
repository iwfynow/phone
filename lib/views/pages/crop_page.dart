import 'package:flutter/material.dart';
import 'package:crop/crop.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:phone/generated/l10n.dart';

class CropPage extends StatelessWidget {
  final XFile? avatarImage;
  final CropController controllerCrop = CropController(aspectRatio: 1);
  CropPage({super.key, required this.avatarImage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).crop_image),
        actions: [
          IconButton(
              onPressed: () async {
                final croppedFile = await controllerCrop.crop();
                final byteData =
                    await croppedFile!.toByteData(format: ImageByteFormat.png);
                final croppedImageData = byteData!.buffer.asUint8List();
                Navigator.pop(context, croppedImageData);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Crop(
          controller: controllerCrop,
          shape: BoxShape.circle,
          child: Image.file(File(avatarImage!.path), fit: BoxFit.cover),
      ),
    );
  }
}
