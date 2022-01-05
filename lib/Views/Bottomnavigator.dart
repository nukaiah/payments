// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:payments/Helpers/constants.dart';
import 'package:payments/Views/Home_View.dart';
import 'package:payments/Views/Profile_View.dart';
import 'package:payments/Views/Transactionlist_View.dart';

class BottomnavigatorScreen extends StatefulWidget {
  @override
  _BottomnavigatorScreenState createState() => _BottomnavigatorScreenState();
}

class _BottomnavigatorScreenState extends State<BottomnavigatorScreen> {

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

  }


  int _currentIndex = 0;
  PageController? _pageController;

  List<Widget> tabPages = [
    HomeScreen(),
    TransactionlistScreen(),
    ProfileScreen(),
  ];

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController!.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: btnColor,
        currentIndex:_currentIndex,
        elevation: 0.0,
        type:BottomNavigationBarType.fixed,
        selectedItemColor:Colors.green ,
        items: [
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon:  Icon(Icons.home_outlined,),title: Text("Home",style: TxtStls.txtStl2,)),
          BottomNavigationBarItem(icon: Icon(Icons.list,),title: Text("Transactions",style: TxtStls.txtStl2,)),
          BottomNavigationBarItem(icon: Icon(Icons.person,),title: Text("Profile",style: TxtStls.txtStl2,)),
        ],
        onTap: onTabTapped
      ),
    );
  }

}
