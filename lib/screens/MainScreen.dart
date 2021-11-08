import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/CategoryScreen.dart';
import 'package:smart_travel_planner/screens/HomeViewScreen.dart';
import 'package:smart_travel_planner/screens/ReviewsScreen.dart';
import 'package:smart_travel_planner/screens/user/LoginScreen.dart';
import 'package:smart_travel_planner/screens/user/SignUpScreen.dart';
import 'package:smart_travel_planner/screens/userProfile/profile.dart';
import '../widgets/icon_badge.dart';
import 'itenerary/IteneraryScreen.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.login,
              color: Colors.amber,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          HomePage(),
          IteneraryScreen(),
          CategoryScreen(),
          ReviewScreen(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7.0),
            barIcon(icon: Icons.home, page: 0,iconKey: const Key('home-button')),
            barIcon(icon: Icons.add_location, page: 1, iconKey: const Key('itinerary-button')),
            barIcon(icon: Icons.favorite, page: 2,iconKey: const Key('category-button')),
            barIcon(
              icon: Icons.mode_comment,
              page: 3,
              iconKey: const Key('comment-button')
            ),
            barIcon(icon: Icons.person, page: 4,iconKey: const Key('profile-button')),
            SizedBox(width: 7.0),
          ],
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() async {
      this._page = page;
    });
  }

  Widget barIcon(
      {IconData icon = Icons.home, int page = 0, bool badge = false, required Key iconKey}) {
    return IconButton(
      key:iconKey,
      icon: badge
          ? IconBadge(
              icon: icon,
              size: 24.0,
              color: Colors.amber,
            )
          : Icon(icon, size: 24.0),
      color:
          _page == page ? Theme.of(context).accentColor : Colors.blueGrey[300],
      onPressed: () => _pageController.jumpToPage(page),
    );
  }
}
