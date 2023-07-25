import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseproject/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/Color.dart';
import '../../resources/Components/Round_Elevated_button.dart';
import '../../resources/Components/Round_button.dart';
import '../../view_models/Auth_View_Model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _addNotesController = TextEditingController();

  //final databaseReference = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.AppBarColor,
          title: Text("Add Notes", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
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
                height: 200, // Set the desired height for the note-like input area
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  controller: _addNotesController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(
                    hintText: "Add Notes",
                  ),
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
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _addNotesController.text.isNotEmpty) {
                      value.AddDataINtoDataBase(
                          _titleController.text.toString(),
                          _addNotesController.text.toString(),
                          context
                      );
                    } else {
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
    );
  }


}

