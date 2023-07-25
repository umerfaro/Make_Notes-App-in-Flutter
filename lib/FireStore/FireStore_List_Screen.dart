import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:full_screen_image/full_screen_image.dart';
import '../resources/Color.dart';
import '../utils/utlis.dart';
import '../view/auth/Login_View.dart';

import '../view_models/Auth_View_Model.dart';
import 'FiteStore_add_Note.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  final _auth = FirebaseAuth.instance;
  double _scale = 1.0;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _editTitleController = TextEditingController();
  TextEditingController _editDescrptionController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
    _editTitleController.dispose();
    _editDescrptionController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final currentUserUID =
        Provider.of<AuthModel>(context, listen: false).getCurrentUser();
    final fireStore = FirebaseFirestore.instance
        .collection(currentUserUID.toString())
        .snapshots();
    CollectionReference ref =
        FirebaseFirestore.instance.collection(currentUserUID.toString());

    print("built");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
           backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: AppColors.ButtonColor,
            title: Text("Home Screen", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(
              color: AppColors.WhiteColor,
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
                width: MediaQuery.sizeOf(context).width * 0.02,
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: fireStore,
                    builder: (BuildContext contex,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Some Error"),
                        );
                      }

                      return Consumer<AuthModel>(
                        builder: (context, authModel, child) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final imageUrl = snapshot.data!.docs[index]['image'].toString();
                                final title = snapshot
                                    .data!.docs[index]['title']
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
                                        leading:imageUrl.isEmpty?  Container(width: 0, height: 0)  :
                                        FullScreenWidget(
                                          disposeLevel: DisposeLevel.Medium,
                                          child: InteractiveViewer(
                                            clipBehavior: Clip.none,
                                            scaleEnabled: true,
                                            maxScale: 2.0, // Set the maximum scale to limit how much the image can be zoomed in
                                            minScale: 1.0, // Set the minimum scale to limit how much the image can be zoomed out// Create a TransformationController
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              placeholder: (context, url) => CircularProgressIndicator(color: Colors.grey[200]),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              fit: BoxFit.contain,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data!.docs[index]['title']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]['description']
                                            .toString()),
                                        //leading: Text(snapshot.child('Id').value.toString()),
                                        trailing: PopupMenuButton(

                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) => [

                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: ListTile(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        ShowMyDialog(
                                                            title,
                                                            snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'description']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['Id']
                                                                .toString(),
                                                            ref);
                                                      },
                                                      leading: Icon(Icons.edit),
                                                      title: Text("Edit"),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: ListTile(
                                                      onTap: () {
                                                        // DeleteNote(snapshot
                                                        //     .data!
                                                        //     .docs[index]['Id']
                                                        //     .toString());
                                                        Navigator.pop(context);
                                                        ref
                                                            .doc(snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['Id']
                                                                .toString())
                                                            .delete();
                                                      },
                                                      leading:
                                                          Icon(Icons.delete),
                                                      title: Text("Delete"),
                                                    ),
                                                  ),
                                                ]),
                                      ),
                                    ),
                                  );
                                } else if (title.toLowerCase().contains(
                                    authModel.getChangeSearch
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
                                        leading:imageUrl.isEmpty?  Container(width: 0, height: 0)  :
                                        FullScreenWidget(
                                          disposeLevel: DisposeLevel.Medium,
                                          child: InteractiveViewer(
                                            clipBehavior: Clip.none,
                                            scaleEnabled: true,
                                            maxScale: 2.0, // Set the maximum scale to limit how much the image can be zoomed in
                                            minScale: 1.0, // Set the minimum scale to limit how much the image can be zoomed out// Create a TransformationController
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              placeholder: (context, url) => CircularProgressIndicator(color: Colors.grey[200]),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              fit: BoxFit.contain,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                        title: Text(title,style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                          snapshot
                                              .data!.docs[index]['description']
                                              .toString(),
                                        ),
                                        // leading:
                                        // Text(snapshot.child('Id').value.toString()),
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
                                                                .data!
                                                                .docs[index][
                                                                    'description']
                                                                .toString(),
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['Id']
                                                                .toString(),
                                                            ref);
                                                      },
                                                      leading: Icon(Icons.edit),
                                                      title: Text("Edit"),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: ListTile(
                                                      onTap: () {
                                                        // DeleteNote(snapshot
                                                        //     .data!
                                                        //     .docs[index]['Id']
                                                        //     .toString());
                                                        Navigator.pop(context);
                                                        ref
                                                            .doc(snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['Id']
                                                                .toString())
                                                            .delete();
                                                      },
                                                      leading:
                                                          Icon(Icons.delete),
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
                              });
                        },
                      );
                    }),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey[700],
            onPressed: () {
              //Navigator.pushNamed(context, RouteNames.AddPostScreen);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FireStoreAddScreen()));
            },
            child: Icon(Icons.add, color: AppColors.WhiteColor),
          ),
        ),
      ),
    );
  }

  Future<void> ShowMyDialog(
      String title, String des, String ID, CollectionReference ref) async {
    _editTitleController.text = title;
    _editDescrptionController.text = des;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[300],
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
                    ref.doc(ID).update({
                      'title': _editTitleController.text.toString(),
                      'description': _editDescrptionController.text.toString(),
                    }).then((value) {
                      Utils.toastMessage("Note Update");
                    }).onError((error, stackTrace) {
                      Utils.flushBarErrorMessage(error.toString(), context);
                    });
                  },
                  child: Text("Update",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700])))
            ],
          );
        });
  }

  // Future<void> DeleteNote(String id) async {
  //   Navigator.pop(context);
  //   ref.doc(id).delete();
  // }
}
