import 'package:flutter/material.dart';
import 'package:crop/crop.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_book/generated/l10n.dart';
import 'package:phone_book/views/pages/settings.dart';
import 'package:phone_book/views/widgets/contact_phone_fields.dart';
import 'package:phone_book/views/widgets/contact_photo_editor.dart';
import '../../viewmodels/contact_view_model.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../pages/crop_page.dart';
import '../widgets/contact_text_field.dart';

class CreateOrEditPage extends StatefulWidget {
  final Contact? contact;
  const CreateOrEditPage({super.key, this.contact});

  @override
  CreateContactPageState createState() => CreateContactPageState();
}

class CreateContactPageState extends State<CreateOrEditPage> {
  Uint8List? avatarImage;
  final cropController = CropController(aspectRatio: 1);
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late Contact contact;
  ContactViewModel cvm = ContactViewModel();

  String dialCode = "";

  double screenHeight = 0;
  double screenWidth = 0;
  bool onAddEmail = false;
  bool onAddCompany = false;
  bool onAddNotes = false;

  late bool isCreated;

  @override
  void initState(){
    super.initState();
    if(widget.contact != null){
      contact = widget.contact!;
      isCreated = false;
    } else{
      contact = Contact();
      isCreated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel)),
        title: Text(S.of(context).create_contact),
        actions: [
          TextButton(
              onPressed: () {
                if (globalKey.currentState!.validate()) {
                  globalKey.currentState!.save();
                  if(isCreated){
                    cvm.addContact(contact);
                    Navigator.pop(context);
                  } else{
                    cvm.update(contact);
                    Navigator.pop(context, contact);
                  }
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.pink, foregroundColor: Colors.white),
              child: Text(S.of(context).save)
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              ContactPhotoEditor(
                  avatarImage: contact.photo ?? avatarImage,
                  onImagePicked: () async {
                    XFile? file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      Uint8List imageCrop = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CropPage(avatarImage: file)));
                      contact.photo = imageCrop;
                      setState(() {
                        avatarImage = imageCrop;
                      });
                    }
                  }),
              ContactTextField(
                label: S.of(context).fname,
                keyboardType: TextInputType.name,
                initialValue: contact.displayName,
                maxLength: 20,
                validator: (String? value) {
                  if (value == null || value.isEmpty){
                    return S.of(context).please_input_name;
                  }
                  return null;
                },
                onSaved: (value) {
                  contact.displayName = value!;
                  contact.name.first = value;
                },
              ),
              ContactTextField(
                label: S.of(context).lname,
                keyboardType: TextInputType.name,
                initialValue: contact.name.last,
                maxLength: 25,
                validator: (String? value) {
                  return null;
                },
                onSaved: (value) {
                  contact.name.last = value!;
                },
              ),
              ContactTextField(
                label: S.of(context).company,
                keyboardType: TextInputType.name,
                initialValue: contact.organizations.isNotEmpty ? contact.organizations.first.company : "",
                maxLength: 25,
                validator: (String? value) {
                  return null;
                },
                onSaved: (value) {
                  contact.organizations = [Organization(company: value!)];
                },
              ),
              ContactPhoneFields(
                label: S.of(context).number,
                keyboardType: TextInputType.number,
                number: contact.phones.isNotEmpty ? contact.phones.first.number : "",
                onSaved: (value) {
                  if(ContactPhoneFields.dialCode != null){
                  dialCode = ContactPhoneFields.dialCode ?? "+7";
                  }
                  contact.phones = [Phone(dialCode + value!)];
                },
              ),
              const SizedBox(height: 20),
              onAddEmail == false ? SizedBox(
                height: screenWidth * 0.12,
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  onPressed: (){
                      setState((){
                        onAddEmail = !onAddEmail;
                      });
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Icon(Icons.add), const SizedBox(width: 10,), Text(S.of(context).add_email)]
                  )
                )
              ) : ContactTextField(
                label: S.of(context).email,
                keyboardType: TextInputType.multiline,
                initialValue: contact.emails.isNotEmpty ? contact.emails.first.address : "",
                maxLength: 25,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  contact.emails = [Email(value!)];
                }
              ),
              const SizedBox(height: 10),
              onAddNotes == false ? SizedBox(
                height: screenWidth * 0.12,
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      onAddNotes = !onAddNotes;
                    });
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Icon(Icons.add),const SizedBox(width: 10), Text(S.of(context).add_notes)]
                  )
                )
              ) : ContactTextField(
                label: S.of(context).notes,
                keyboardType: TextInputType.multiline,
                initialValue: contact.notes.isNotEmpty ? contact.notes.first.note : "",
                maxLength: 100,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  contact.notes = [Note(value!)];
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
