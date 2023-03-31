// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/screen/profile.dart';
import 'package:onlineshopping/screen/search.dart';
import 'Favorites.dart';
import 'cart_screen.dart';
import 'home.dart';
import 'order_history.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex=0;
  FirebaseAuth _auth;
  User user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex=index;
    });
    if(currentTabIndex==3){
    }
  }

  final currentPage = [
    HomeScreen(),
    Search(),
    CartScreen(false),
   // FavoriteScreen(),
    //OrderHistoryScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: currentPage[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: currentTabIndex,
          unselectedItemColor: Colors.black54,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
              icon:   Image.asset('images/category/shop.png'),

              //Icon(Icons.home),
              title: Text("Shop",style: TextStyle(color:  Theme.of(context).accentColor),),
            ),
            BottomNavigationBarItem(
              icon:  Image.asset('images/category/search.png'),
              title: Text("Explore",style: TextStyle(color:  Theme.of(context).accentColor),),
            ),
            BottomNavigationBarItem(

              icon:StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart').snapshots(),
      builder: (context, snapshot) {
      return Stack(
      children: [
        Image.asset('images/category/cart.png'),
      Positioned(
      top:0,
      right:0,

      child:snapshot.data?.docs?.length==null? CircularProgressIndicator(): Container(
      width:13,
      height:13,
      decoration: BoxDecoration(
      color:Colors.red,
      borderRadius: BorderRadius.all(
      Radius.circular(15)
      //                 <--- border radius here
      ),
      //   border: Border.all(color: Colors.black12,width: 0.6),
      ),
      child: Center(
      child:
      Text(snapshot.data?.docs?.length.toString() ?? '0',
      style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),),
      ))
      )
      ],
      );
      }
      ),
              title: Text('Cart',style: TextStyle(color:  Theme.of(context).accentColor),),
              // backgroundColor: Colors.purple[600]
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.favorite_border),
            //   title: Text('Favorite'),
            //   // backgroundColor: Colors.purple[600]
            // ),
            BottomNavigationBarItem(
              icon:  Image.asset('images/category/profile.png',width: 40,height: 40,),
              title: Text("Profile",style: TextStyle(color:  Theme.of(context).accentColor),),
            ),
          ],
        ),
      ),
    );
  }
}