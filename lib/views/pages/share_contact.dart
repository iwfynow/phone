import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:phone_book/generated/l10n.dart';
import 'package:phone_book/models/contact_mapper.dart';
import 'package:share_plus/share_plus.dart';

class ShareContact extends StatefulWidget {
  final Contact contact;
  const ShareContact({super.key, required this.contact});

  @override
  ShareContactState createState() => ShareContactState();
}

class ShareContactState extends State<ShareContact> {

  bool _includePhoto = true;
  bool _includeName = true;
  bool _includePhone = true;
  bool? onShowPhoto;
  int bitFlag = 0;

  @override
  void initState(){
    super.initState();
    if(widget.contact.photo == null){
      onShowPhoto = false;
    } else{
      onShowPhoto = true;
    }
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(S.of(context).share_contact),
      content: onShowPhoto == true ? SizedBox(
            height: 100,
            width: 100,
            child: 
            CircleAvatar(child:  ClipOval(child: Image.memory((widget.contact.photo!))))
          ) : const SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(child: Icon(Icons.person))
            ) ,
      actions: [
        onShowPhoto == true ? CheckboxListTile(controlAffinity: ListTileControlAffinity.leading, value: _includePhoto, 
        title: Text(S.of(context).photo), onChanged: (flag){
          setState(() {
            _includePhoto = flag!;
          });
        }) : Container() ,
        CheckboxListTile(controlAffinity: ListTileControlAffinity.leading, value: _includeName, 
        title: Text(widget.contact.displayName), 
        subtitle: Text(S.of(context).name), onChanged: (flag){
          setState(() {
            _includeName = flag!;
          });
        }),
        CheckboxListTile(controlAffinity: ListTileControlAffinity.leading, value: _includePhone, 
        title: Text(widget.contact.name.first), subtitle: Text(S.of(context).photo), onChanged: (flag){
          setState(() {
            _includePhone = flag!;
          });
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text(S.of(context).cancel, style: const TextStyle(fontSize: 16))),
          TextButton(onPressed: () async {
            bitFlag = 0;
            if(_includePhoto){
              bitFlag+= 1;
            }
            if(_includeName){
              bitFlag+=2;
            }
            if(_includePhone){
              bitFlag+= 4;
            }
            var vcfText = widget.contact.toVcard(contact: widget.contact, bitFlag: bitFlag);
            XFile file = XFile.fromData(Uint8List.fromList(vcfText.codeUnits), name: "${widget.contact.displayName}.vcf", mimeType: 'text/x-vcard');
            await Share.shareXFiles([file], text: widget.contact.displayName);
          }, child: Text(S.of(context).continues , style: const TextStyle(fontSize: 16)))
        ],)
      ],
    );
  }
}