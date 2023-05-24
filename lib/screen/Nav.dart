import 'package:blog_app_test/contant/Contant.dart';
import 'package:blog_app_test/screen/profile_page/profile.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'home_page/home.dart';
import 'search_page/search.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int currentIndex = 0;

  late Home home;

  late Search search;

  late Profile profile;

  late List<Widget> pages;

  late Widget currentpage;

  @override
  void initState() {
    home = Home();

    profile = Profile();
    search = Search();
    pages = [home, search, profile];

    currentpage = home;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: SlidingClippedNavBar.colorful(
          backgroundColor: Colors.white,
          onButtonPressed: (int index) {
            setState(() {
              currentIndex = index;
              currentpage = pages[index];
            });
          },
          iconSize: 25,
          selectedIndex: currentIndex,
          barItems: [
            BarItem(
              icon: Icons.home_outlined,
              title: 'Explore',
              activeColor: green,
              inactiveColor: black,
            ),
            BarItem(
              icon: Icons.chat_bubble_outline,
              title: 'Search',
              activeColor: green,
              inactiveColor: black,
            ),

            BarItem(
              icon: Icons.person_outline,
              title: 'Search ',
              activeColor: green,
              inactiveColor: black,
            ),

            /// Add more BarItem if you want
          ],
        ),
      ),
      body: currentpage,
    );
  }
}
