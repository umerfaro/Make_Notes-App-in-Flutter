import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebaseproject/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../resources/Color.dart';

import '../../view_models/Auth_View_Model.dart';
import '../auth/Login_View.dart';
import 'add_post_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');

  TextEditingController _searchController = TextEditingController();
  TextEditingController _editTitleController = TextEditingController();
  TextEditingController _editDescrptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("built");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.AppBarColor,
            title: Text("Home Screen", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.white, // Set your desired color here
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                    // Navigator.pushNamed(context, RouteNames.login);
                  }).onError((error, stackTrace) {
                    Utils.flushBarErrorMessage(error.toString(), context);
                  });
                },
                icon: Icon(Icons.logout),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height:
                      50, // Set the desired height for the title input field
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Search notes",
                    ),
                    onChanged: (String values) {
                      final authModel =
                          Provider.of<AuthModel>(context, listen: false);
                      authModel.changeSearchState(values);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Consumer<AuthModel>(
                  builder: (context, authModel, child) {
                    return FirebaseAnimatedList(
                      defaultChild: Center(child: CircularProgressIndicator()),
                      query: ref,
                      itemBuilder: (context, snapshot, animation, index) {
                        final title = snapshot
                            .child('title')
                            .value
                            .toString()
                            .toLowerCase();

                        if (_searchController.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors
                                      .grey, // Optional: Add a border to the input area
                                  width: 1.0,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  snapshot.child('title').value.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(snapshot
                                    .child('description')
                                    .value
                                    .toString()),
                                //leading: Text(snapshot.child('Id').value.toString()),
                                trailing: PopupMenuButton(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                ShowMyDialog(
                                                    title,
                                                    snapshot
                                                        .child('description')
                                                        .value
                                                        .toString(),
                                                    snapshot
                                                        .child('Id')
                                                        .value
                                                        .toString()
                                                );
                                              },
                                              leading: Icon(Icons.edit),
                                              title: Text("Edit"),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: (){
                                                DeleteNote(snapshot
                                                    .child('Id')
                                                    .value
                                                    .toString());
                                              },
                                              leading: Icon(Icons.delete),
                                              title: Text("Delete"),
                                            ),
                                          ),
                                        ]),
                              ),
                            ),
                          );
                        }

                        else if (title.toLowerCase().contains(authModel
                            .getChangeSearch
                            .toLowerCase()
                            .toString())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors
                                      .grey, // Optional: Add a border to the input area
                                  width: 1.0,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                    snapshot.child('title').value.toString()),
                                subtitle: Text(snapshot
                                    .child('description')
                                    .value
                                    .toString()),
                                leading:
                                    Text(snapshot.child('Id').value.toString()),
                                trailing: PopupMenuButton(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            ShowMyDialog(
                                                title,
                                                snapshot
                                                    .child('description')
                                                    .value
                                                    .toString(),
                                                snapshot
                                                    .child('Id')
                                                    .value
                                                    .toString()
                                            );
                                          },
                                          leading: Icon(Icons.edit),
                                          title: Text("Edit"),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: (){
                                            DeleteNote(snapshot
                                                .child('Id')
                                                .value
                                                .toString());
                                          },
                                          leading: Icon(Icons.delete),
                                          title: Text("Delete"),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.AppBarColor,
            onPressed: () {
              //Navigator.pushNamed(context, RouteNames.AddPostScreen);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPostScreen()));
            },
            child: Icon(Icons.add, color: AppColors.WhiteColor),
          ),
        ),
      ),
    );
  }

  Future<void> ShowMyDialog(String title, String des, String ID) async {
    _editTitleController.text = title;
    _editDescrptionController.text = des;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _editTitleController,
                    decoration: InputDecoration(
                      hintText: "Edit Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  Container(
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
                    child: TextFormField(
                      controller: _editDescrptionController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Edit Description",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(ID).update({
                      'title': _editTitleController.text.toString(),
                      'description': _editDescrptionController.text.toString(),
                    }).then((value) {
                      Utils.toastMessage("Note Update");
                    }).onError((error, stackTrace) {
                      Utils.flushBarErrorMessage(error.toString(), context);
                    });
                  },
                  child: Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
Future<void>DeleteNote(String id)async{
    Navigator.pop(context);
    ref.child(id).remove();
}

}

/// this is for fetches data from firebase using streambuilder

// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (snapshot.hasData) {
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// border: Border.all(
// color: Colors
//     .grey, // Optional: Add a border to the input area
// width: 1.0,
// ),
// ),
// child: ListTile(
// title:
// Text(list[index]['title'].toString()),
// subtitle: Text(
// list[index]['description'].toString()),
// leading: Text(list[index]['Id'].toString()),
// ),
// ),
// );
// });
// } else {
// return Center(child: CircularProgressIndicator());
// }
// },
// ),
// ),
