import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../resources/Components/Round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/utlis.dart';
import '../view_models/Auth_View_Model.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final fireStore = FirebaseFirestore.instance
      .collection(AuthModel().getCurrentUser().toString());

  Future getGalleryImage() async {
    final pickFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer(builder: (context, AuthModel value, child) {
            return RoundButton(
              loading: value.getaddloading,
              text: 'Upload',
              onPressed: () async {
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref(value.getCurrentUser().toString())
                    .child(id);
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);

                value.AddDataloadingchnage(true);
                await Future.value(uploadTask).then((valuess) async {
                  var url = await ref.getDownloadURL();

                  fireStore.doc(id).set({
                    'Imageid': id,
                    'image': url,
                  }).then((values) {
                    value.AddDataloadingchnage(false);
                    Utils.toastMessage("Data Added Successfully");
                  }).onError((error, stackTrace) {
                    value.AddDataloadingchnage(false);
                  });
                }).onError((error, stackTrace) {
                  value.AddDataloadingchnage(false);
                  Utils.flushBarErrorMessage(error.toString(), context);
                });
              },
            );
          })
        ],
      ),
    );
  }
}
