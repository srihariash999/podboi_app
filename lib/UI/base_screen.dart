import 'package:flutter/material.dart';
import 'package:podboi/UI/home_page.dart';
import 'package:podboi/UI/subscriptions_page.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedPage = 0;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 2,
        onPageChanged: (newIndex) {
          setState(() {
            _selectedPage = newIndex;
          });
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return HomePage();
          } else {
            return SubscriptionsPage();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (newIndex) {
          setState(() {
            _selectedPage = newIndex;
          });
          _pageController.animateToPage(newIndex,
              duration: Duration(
                milliseconds: 500,
              ),
              curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Color(0xFF4E3878),
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Home',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4E3878),
                  fontFamily: 'Segoe'),
            ),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.book,
              color: Color(0xFF4E3878),
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Subscriptions',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4E3878),
                  fontFamily: 'Segoe'),
            ),
            icon: Icon(Icons.book),
          ),
        ],
      ),
    );
  }
}
