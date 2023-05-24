import 'package:blog_app_test/screen/login_page/login.dart';
import 'package:blog_app_test/screen/upload_ppage/upload_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbRef = FirebaseDatabase.instance.ref().child('Post');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {}),
          icon: Icon(Icons.menu),
          iconSize: 30,
        ),
        title: Text("Blog App"),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return Upload_Page();
                })));
              }),
              icon: Icon(Icons.add_circle)),
          IconButton(
              onPressed: (() {
                firebaseAuth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Login())));
                });
              }),
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef.child('Post List'),
                itemBuilder: (context, snapshot, animation, index) {
                  final data = snapshot.value;
                  data as Map;
                  return Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                        color: Color.fromARGB(135, 209, 201, 201)),
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['pTitle']),
                          Text(data['pContect']),
                          Text(data['pDes']),
                          Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                            overflow: TextOverflow.clip,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: size.width,
                            height: size.height * 0.3,
                            child: FadeInImage.assetNetwork(
                              width: size.width,
                              height: size.height * 0.2,
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/pp.png',
                              image: data['pImage'],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: size.width,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                "Message Me",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
