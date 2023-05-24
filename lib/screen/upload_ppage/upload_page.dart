import 'dart:io';
import 'package:blog_app_test/contant/Contant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_store;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Upload_Page extends StatefulWidget {
  const Upload_Page({super.key});

  @override
  State<Upload_Page> createState() => _Upload_PageState();
}

class _Upload_PageState extends State<Upload_Page> {
  final post = FirebaseDatabase.instance.ref().child('Post');
  firebase_store.FirebaseStorage storage =
      firebase_store.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showspinner = false;

  File? file;
  final picker = ImagePicker();
  TextEditingController titletextController = TextEditingController();
  TextEditingController destextController = TextEditingController();
  TextEditingController emailtextController = TextEditingController();

  Future getImageGallery() async {
    final piFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (piFile != null) {
        file = File(piFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future getCameraImage() async {
    final piFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (piFile != null) {
        file = File(piFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  void diaLog(context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(children: [
                InkWell(
                  onTap: (() {
                    getCameraImage();
                    Navigator.pop(context);
                  }),
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
                InkWell(
                  onTap: (() {
                    getImageGallery();
                    Navigator.pop(context);
                  }),
                  child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Gallery"),
                  ),
                )
              ]),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Post Page",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: green),
                ),
                SizedBox(
                  height: 60,
                ),
                GestureDetector(
                  onTap: (() {
                    diaLog(context);
                  }),
                  child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(80)),
                      child: file != null
                          ? ClipRect(
                              child: Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(80),
                                    image: DecorationImage(
                                        image: FileImage(file!),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(Icons.person),
                                  Text("Upload\n Photo")
                                ])),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 350,
                  child: TextFormField(
                      controller: titletextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: Text("Enter Title"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  child: TextFormField(
                      controller: destextController,
                      keyboardType: TextInputType.text,
                      minLines: 4,
                      maxLines: 4,
                      decoration: InputDecoration(
                        label: Text("Description"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      )),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  child: TextFormField(
                      controller: emailtextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: Text("Enter Contect"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                // Container(
                //   width: 350,
                //   child: DropdownButtonFormField<int>(
                //       onChanged: ((value) {}),
                //       items: [
                //         DropdownMenuItem(
                //           child: Text("Website"),
                //           value: 1,
                //         ),
                //       ],
                //       decoration: InputDecoration(
                //         label: Text("Select Category"),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(30)),
                //       )),
                // ),

                GestureDetector(
                  onTap: (() async {
                    setState(() {
                      showspinner = true;
                    });

                    try {
                      int date = DateTime.now().microsecondsSinceEpoch;
                      firebase_store.Reference ref = firebase_store
                          .FirebaseStorage.instance
                          .ref('/blogapp$date');

                      UploadTask uploadTask = ref.putFile(file!.absolute);

                      await Future.value(uploadTask);
                      var url = await ref.getDownloadURL();

                      final User? user = _auth.currentUser;

                      post.child('Post List').child(date.toString()).set({
                        'pId': date.toString(),
                        'pImage': url.toString(),
                        'pTime': date.toString(),
                        'pTitle': titletextController.text.toString(),
                        'pDes': destextController.text.toString(),
                        'pContect': emailtextController.text.toString(),
                        'uEmail': user!.email.toString(),
                        'uId': user.uid.toString(),
                      }).then((value) {
                        toastMessage('Post Published');
                        setState(() {
                          showspinner = false;
                        });
                      }).onError((error, stackTrace) {
                        toastMessage(error.toString());
                      });
                    } catch (e) {
                      setState(() {
                        showspinner = false;
                      });
                      toastMessage(e.toString());
                    }
                  }),
                  child: Container(
                    alignment: Alignment.center,
                    width: 350,
                    height: 55,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black,
                          green,
                        ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Post",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}



// Image.file(
//                               file!.absolute,
//                               width: 140,
//                               height: 140,
                              
//                             ),
