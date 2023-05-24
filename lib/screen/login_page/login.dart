import 'package:blog_app_test/contant/Contant.dart';
import 'package:blog_app_test/screen/Nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../regsiter_page/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  bool showSpinner = false;

  String email = "", password = "";
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
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black,
            green,
          ])),
          child: Form(
            key: _fromKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  height: 510,
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
                      "Please Login in here ",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 40,
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
                            label: Text("Email"),
                            suffixIcon: Icon(Icons.email),
                          )),
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
                            label: Text("Password"),
                            suffixIcon: Icon(Icons.password),
                          )),
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
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email.toString().trim(),
                                password: password.toString().trim());
                            if (user != null) {
                              print("success");
                              toastMessage("User successful Login");
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: ((context) {
                                return Nav();
                              })));
                              Navigator.pop(context);
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
                            "Login",
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
                          return Register();
                        })));
                      }),
                      child: Text(
                        "Register Here",
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: (() {}),
                            icon: Icon(
                              Icons.facebook,
                              size: 30,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: (() {}),
                            icon: Icon(
                              Icons.wechat,
                              size: 30,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: (() {}),
                            icon: Icon(
                              Icons.gite,
                              size: 30,
                              color: Colors.blue,
                            )),
                      ],
                    )
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
