import 'package:blog_app_test/contant/Contant.dart';
import 'package:blog_app_test/screen/login_page/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_store;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  bool showSpinner = false;
  final post = FirebaseDatabase.instance.ref().child('Post');

  String email = "", password = "", userName = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: green,
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black,
            green,
          ])),
          child: Form(
            key: _fromKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    Text(
                      "HELLO",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Register in here ",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        validator: ((value) {
                          return value!.isEmpty ? "Enter Username" : null;
                        }),
                        onChanged: ((value) {
                          userName = value;
                        }),
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintText: "Username",
                          suffixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        validator: ((value) {
                          return value!.isEmpty ? "Enter email" : null;
                        }),
                        onChanged: ((value) {
                          email = value;
                        }),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          suffixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        validator: ((value) {
                          return value!.isEmpty ? "Enter Password" : null;
                        }),
                        onChanged: ((value) {
                          password = value;
                        }),
                        obscureText: true,
                        controller: passController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          suffixIcon: Icon(Icons.password),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (() async {
                        if (_fromKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final user = await _auth
                                .createUserWithEmailAndPassword(
                                    email: email.toString().trim(),
                                    password: password.toString().trim())
                                .then((value) {
                              post.child(value.user!.uid.toString()).set({
                                'uid': value.user!.uid.toString(),
                                'uEmail': value.user!.email.toString(),
                                'userName': userName.toString()
                              }).then((value) {
                                toastMessage('Finished');
                                setState(() {
                                  showSpinner = false;
                                });
                              }).onError((error, stackTrace) {
                                toastMessage(error.toString());
                              });
                            });
                            if (user != null) {
                              print("success");
                              toastMessage("User successful");
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            print(e.toString());
                            toastMessage(e.toString());
                          }
                        }
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.black,
                              green,
                            ]),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Or",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return Login();
                        })));
                      }),
                      child: Text(
                        "Login Here",
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                )
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



// onTap: (() async {
//                     setState(() {
//                       showspinner = true;
//                     });

//                     try {
//                       int date = DateTime.now().microsecondsSinceEpoch;
//                       firebase_store.Reference ref = firebase_store
//                           .FirebaseStorage.instance
//                           .ref('/blogapp$date');

//                       UploadTask uploadTask = ref.putFile(file!.absolute);

//                       await Future.value(uploadTask);
//                       var url = await ref.getDownloadURL();

//                       final User? user = _auth.currentUser;

//                       post.child('Post List').child(date.toString()).set({
//                         'pId': date.toString(),
//                         'pImage': url.toString(),
//                         'pTime': date.toString(),
//                         'pTitle': titletextController.text.toString(),
//                         'pDes': destextController.text.toString(),
//                         'pContect': emailtextController.text.toString(),
//                         'uEmail': user!.email.toString(),
//                         'uId': user.uid.toString(),
//                       }).then((value) {
//                         toastMessage('Post Published');
//                         setState(() {
//                           showspinner = false;
//                         });
//                       }).onError((error, stackTrace) {
//                         toastMessage(error.toString());
//                       });
//                     } catch (e) {
//                       setState(() {
//                         showspinner = false;
//                       });
//                       toastMessage(e.toString());
//                     }
//                   }),
