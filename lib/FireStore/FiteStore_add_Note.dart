import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseproject/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../resources/Color.dart';
import '../../resources/Components/Round_button.dart';
import '../../view_models/Auth_View_Model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class FireStoreAddScreen extends StatefulWidget {
  const FireStoreAddScreen({super.key});

  @override
  State<FireStoreAddScreen> createState() => _FireStoreAddScreenState();
}

class _FireStoreAddScreenState extends State<FireStoreAddScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _addNotesController = TextEditingController();


  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final fireStore= FirebaseFirestore.instance.collection(AuthModel().getCurrentUser().toString());

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
  void dispose()
  {
    super.dispose();

    _titleController.dispose();
    _addNotesController.dispose();

  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
   // final currentUserUID = Provider.of<AuthModel>(context).getCurrentUser();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.BlackColor,
          title: Text("Add Notes", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height * 0.1,
                  width: height * 0.1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/add.png"))),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50, // Set the desired height for the title input field
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Title",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height:
                      200, // Set the desired height for the note-like input area
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(

                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80, // Set the desired fixed width for the container
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey, // Set the background color for the container
                            ),
                            child: _image != null
                                ? Image.file(
                              _image!.absolute,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover, // Set the fit property to cover the entire area of the container
                            )
                                : null, // Set the Image widget if _image is not null
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.image) ,
                              onPressed: () {
                                getGalleryImage();
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(

                          controller: _addNotesController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration.collapsed(

                            hintText: "Add Notes",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Consumer<AuthModel>(
                builder: (context, value, child) {
                  return RoundButton(
                    text: "Add",
                    onPressed: () async {

                    //  String id =DateTime.now().microsecondsSinceEpoch.toString();
                      String id =Uuid().v4();

                      if (_titleController.text.isNotEmpty && _addNotesController.text.isNotEmpty   && _image!=null) {


                        value.AddDataloadingchnage(true);

                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref(value.getCurrentUser().toString())
                            .child(id);
                        firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);
                        await Future.value(uploadTask).then((values) async {
                          var url = await ref.getDownloadURL();

                          fireStore.doc(id).set({
                            'title': _titleController.text.toString(),
                            'Id': id,
                            'description': _addNotesController.text.toString(),
                            'image': url,
                          }).then((values) {
                            value.AddDataloadingchnage(false);
                            Utils.toastMessage("Data Added Successfully with image");
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            value.AddDataloadingchnage(false);
                            Utils.flushBarErrorMessage(error.toString(), context);
                          });

                        }).onError((error, stackTrace) {
                          value.AddDataloadingchnage(false);
                          Utils.flushBarErrorMessage(error.toString(), context);
                        });



                      }else if ( _titleController.text.isNotEmpty && _addNotesController.text.isNotEmpty   && _image==null  ){

                        value.AddDataloadingchnage(true);
                        fireStore.doc(id).set({
                          'title': _titleController.text.toString(),
                          'Id': id,
                          'description': _addNotesController.text.toString(),
                          'image': "",
                        }).then((values) {
                          value.AddDataloadingchnage(false);
                          Utils.toastMessage("Data Added Successfully");
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          value.AddDataloadingchnage(false);
                          Utils.flushBarErrorMessage(error.toString(), context);
                        });

                      }

                      else {
                        Utils.flushBarErrorMessage(
                            "Please Enter Title and Notes", context);
                      }
                    },
                    loading: value.getaddloading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
