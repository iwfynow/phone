import 'dart:typed_data';
import 'package:phone/generated/l10n.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactPhotoEditor extends StatelessWidget {
  Uint8List? avatarImage;
  Function onImagePicked;
  ContactPhotoEditor(
      {super.key, required this.avatarImage, required this.onImagePicked});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onImagePicked(),
      child: Column(children: [
        CircleAvatar(
          minRadius: screenWidth * 0.2,
          child: avatarImage == null
              ? const Icon(Icons.image_search_rounded)
              : ClipOval(
                  child: Image.memory(
                  avatarImage!,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                )),
        ),
        Text(S.of(context).add_picture)
      ]),
    );
  }
}
