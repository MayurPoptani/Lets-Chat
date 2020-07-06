import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:lets_chat/ChatListScreen/screens/ChatListScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lets_chat/global/themes.dart';
import 'package:lets_chat/main.dart';
import 'package:flutter/material.dart';

class MainPagesScreen extends StatefulWidget {
  @override
  _MainPagesScreenState createState() => _MainPagesScreenState();
}

class _MainPagesScreenState extends State<MainPagesScreen> {
  
  int _pageIndex = 1;
  PageController _pageController;
  
  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex, keepPage: true);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: appBar(),
        body: PageView(
          controller: _pageController,
          children: [
            Container(child: "Page 1. Dummy".text.makeCentered(),),
            ChatListScreen(key: PageStorageKey("ChatListScreen-Key"),),
            Container(child: "Page3. Dummy".text.makeCentered(),),
            Container(child: "Page 4. Dummy".text.makeCentered(),),
          ],
          allowImplicitScrolling: false,
          pageSnapping: true,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }
  
  Widget appBar() {
    return AppBar(
      elevation: 8,
      title: Text("Let's Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,)),
      centerTitle: true,
      actions: [
        ThemeSwitcher(
          clipper: ThemeSwitcherCircleClipper(),
          builder: (_) {
            return IconButton(icon: Icon(Icons.lightbulb_outline), onPressed: () {
              LetsChat.isDark = !LetsChat.isDark;
              ThemeSwitcher.of(_).changeTheme(theme: !LetsChat.isDark?lightTheme:darkTheme);
            });
          },
        ),
      ],
    );
  }
  
  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _pageIndex,
      items: [
        getBottomNavItem(Icons.device_hub, "Network"),
        getBottomNavItem(Icons.message, "Messages"),
        getBottomNavItem(Icons.contacts, "Contacts"),
        getBottomNavItem(Icons.library_books, "Library"),
      ],
      onTap: (index) async {
        _pageIndex = index;
        if(mounted) _pageController.animateToPage(_pageIndex, duration: Duration(milliseconds: 150), curve: Curves.ease).then((value) {
          if(mounted) setState(() {});
        });  
      },
    );
  }
  
  BottomNavigationBarItem getBottomNavItem(IconData iconData, String label) {
    return BottomNavigationBarItem(
      // title: label.text.size(12).medium.make(),
      title: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
      icon: Icon(iconData),
      activeIcon: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(iconData),
          ),
          Positioned(
            top: 0, right: 0,
            child: Container(
              height: 10, width: 10, 
              decoration: BoxDecoration(
                color: LetsChat.isDark?Color(0xFF00AEEF):Colors.blue[500],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      )
    );
  }
}