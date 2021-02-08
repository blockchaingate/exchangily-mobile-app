import 'package:exchangilymobileapp/screens/shop/shopHome.dart';
import 'package:exchangilymobileapp/screens/shop/wishList.dart';
import 'package:exchangilymobileapp/screens/shop/cart.dart';
import 'package:exchangilymobileapp/screens/shop/orders.dart';
import 'package:exchangilymobileapp/screens/shop/shopAccount.dart';
import 'package:flutter/material.dart';

class ShopNav extends StatefulWidget {
  ShopNav({Key key, this.pagenum = 0}) : super(key: key);

  final int pagenum;

  @override
  _ShopNavState createState() => new _ShopNavState();
}

class _ShopNavState extends State<ShopNav> {
  PageController _pageController;
  int _page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ShopHome(),
          WishList(),
          Cart(),
          Orders(),
          ShopAccount()
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.pink,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Wish List"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Orders"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Account"),
          ),
        ],
        onTap: navigateToPage,
        currentIndex: _page,
      ),
    );
  }

  void navigateToPage(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = new PageController();
  // }

  @override
  void initState() {
    super.initState();
    _page = widget.pagenum;
    _pageController = PageController(initialPage: widget.pagenum);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
