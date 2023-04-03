// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/Widgets/guestProfile.dart';
import 'package:onlineshopping/Widgets/language_bottom_sheet.dart';
import 'package:onlineshopping/Widgets/profileavatarWidget.dart';
import 'package:onlineshopping/app/Application.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/about_us.dart';
import 'package:onlineshopping/screen/address/addresses_list.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

import 'Favorites.dart';
import 'order_history.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool guest =true;
  User user;
  FirebaseAuth _auth;
  String name='';
  String phone='';
  String address='';
  DocumentSnapshot userInfo;
  Future getUserInfo()async{
    userInfo= await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    setState(() {
     name= userInfo.data()['username'];
     phone= userInfo.data()['phone'];
     address = userInfo.data()['address'];
     print(name);
    });
  }
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth= FirebaseAuth.instance;
    user=_auth.currentUser;
    if( FirebaseAuth.instance.currentUser != null ){
      getUserInfo();
    }

    setState(() {
      _textFieldController = TextEditingController(text: address.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return   FirebaseAuth.instance.currentUser != null ?
    Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trans("profile"),),
        elevation: 0.6,
        automaticallyImplyLeading: false,),
      // drawer: DrawerWidget(),
      body:
          SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ProfileAvatarWidget(
            //   name:name ?? '',
            //   phoneNumber: phone ?? '',
            // ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),

              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots(),
                  builder: (context, snapshot) {
                    return
                      snapshot.data==null?
                      SizedBox():

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                           child:  Row(
                             children: [
                               Image.asset('images/category/profile.png',width: 70,color:Theme.of(context).accentColor,),
                               SizedBox(width: 10,),
                               Text(snapshot.data['username'].toString(),style: TextStyle(fontSize: 17),),
                             ],
                           ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                                onTap: () {
                                  _textFieldController = TextEditingController(text:  snapshot.data['username'].toString());
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:  Text( AppLocalizations.of(context).trans("EditYourName"),),
                                          content: TextField(
                                            controller: _textFieldController,
                                          ),
                                          actions: <Widget>[


                                            ElevatedButton(
                                              child: Text(AppLocalizations.of(context).trans("cancel"),),
                                              onPressed: () => Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                            ElevatedButton(
                                              child:  Text(AppLocalizations.of(context).trans("edit"),),
                                              onPressed: () {
                                                // widget.address=_textFieldController.text;
                                                FirebaseFirestore.instance
                                                    .collection("users").doc(user.uid).update({
                                                  "username":  _textFieldController.text,
                                                  // "subPrice": (cartInfo.data()['quantity'] +1) * cartInfo.data()['price']
                                                });
                                                Navigator.pop(context);

                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold)),

                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(Icons.edit_outlined)),
                          ),
                         // SizedBox(width: 2,),
                        ],
                      );
                  }
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
              child: Text( AppLocalizations.of(context).trans("Dashboard"),style: TextStyle(color: Colors.grey[600]),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // address
                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots(),
                  //     builder: (context, snapshot) {
                  //       return
                  //         snapshot.data==null?
                  //         SizedBox():
                  //
                  //         ListTile(
                  //             onTap: () {
                  //               _textFieldController = TextEditingController(text:  snapshot.data['address'].toString());
                  //               showDialog(
                  //                   context: context,
                  //                   builder: (context) {
                  //                     return AlertDialog(
                  //                       title: const Text('Edit Your Address'),
                  //                       content: TextField(
                  //                         controller: _textFieldController,
                  //                         decoration: const InputDecoration(hintText: "New Address"),
                  //                       ),
                  //                       actions: <Widget>[
                  //
                  //
                  //                         ElevatedButton(
                  //                           child: Text('Cancel'),
                  //                           onPressed: () => Navigator.pop(context),
                  //                           style: ElevatedButton.styleFrom(
                  //                               primary: Colors.red,
                  //                               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //                               textStyle: TextStyle(
                  //                                   fontSize: 18,
                  //                                   fontWeight: FontWeight.bold)),
                  //                         ),
                  //                         ElevatedButton(
                  //                             child: const Text('Edit'),
                  //                             onPressed: () {
                  //                               // widget.address=_textFieldController.text;
                  //                               FirebaseFirestore.instance
                  //                                   .collection("users").doc(user.uid).update({
                  //                                 "address":  _textFieldController.text,
                  //                                 // "subPrice": (cartInfo.data()['quantity'] +1) * cartInfo.data()['price']
                  //                               });
                  //                               Navigator.pop(context);
                  //
                  //                             },
                  //                     style: ElevatedButton.styleFrom(
                  //                     primary: Colors.green,
                  //                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //                     textStyle: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),
                  //
                  //                         ),
                  //                       ],
                  //                     );
                  //                   });
                  //
                  //
                  //             },
                  //             dense: true,
                  //             leading: Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                   color: Colors.cyan[300],
                  //                   shape: BoxShape.circle
                  //               ),
                  //               child: Icon(
                  //                 Icons.location_city_sharp,
                  //                 size: 22,
                  //                 color: Theme.of(context).primaryColor,
                  //               ),
                  //             ),
                  //             title: Text(
                  //               AppLocalizations.of(context).trans("My Address"),
                  //               style: Theme.of(context).textTheme.subtitle1,
                  //             ),
                  //             trailing:  Icon(Icons.edit_outlined,color: Colors.grey[600],));
                  //
                  //
                  //     }
                  // ),
            ListTile(
                onTap: () {

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return AddressesList();
                    }
                  ));
                  // _textFieldController = TextEditingController(text:  snapshot.data['address'].toString());
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: const Text('Edit Your Address'),
                  //         content: TextField(
                  //           controller: _textFieldController,
                  //           decoration: const InputDecoration(hintText: "New Address"),
                  //         ),
                  //         actions: <Widget>[
                  //
                  //
                  //           ElevatedButton(
                  //             child: Text('Cancel'),
                  //             onPressed: () => Navigator.pop(context),
                  //             style: ElevatedButton.styleFrom(
                  //                 primary: Colors.red,
                  //                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //                 textStyle: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold)),
                  //           ),
                  //           ElevatedButton(
                  //               child: const Text('Edit'),
                  //               onPressed: () {
                  //                 // widget.address=_textFieldController.text;
                  //                 FirebaseFirestore.instance
                  //                     .collection("users").doc(user.uid).update({
                  //                   "address":  _textFieldController.text,
                  //                   // "subPrice": (cartInfo.data()['quantity'] +1) * cartInfo.data()['price']
                  //                 });
                  //                 Navigator.pop(context);
                  //
                  //               },
                  //       style: ElevatedButton.styleFrom(
                  //       primary: Colors.green,
                  //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //       textStyle: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold)),
                  //
                  //           ),
                  //         ],
                  //       );
                  //     });


                },
                dense: true,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.cyan[300],
                      shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.location_city_sharp,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context).trans("myAddress"),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
               // trailing:  Icon(Icons.edit_outlined,color: Colors.grey[600],)
              ),
                  SizedBox(height: 15,),
                  //my order
                  ListTile(
                      onTap: () {

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen(),
                        ));
                      },
                      dense: true,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.teal[300],
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.shopping_basket_outlined,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context).trans("my_orders"),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,size: 18,)),
                  SizedBox(height: 15,),
                  //favorite
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FavoriteScreen(),
                        ));
                      },
                      dense: true,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent[400],
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.favorite_border_sharp,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context).trans("Favorite"),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,size: 18)),
                  SizedBox(height: 15,),
                  //language
                  ListTile(
                      onTap: () {
                        LanguageBottomSheet.showLanguageBottomSheet(context);
                      },
                      dense: true,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.translate,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context).trans("language"),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,size: 18)),
                  SizedBox(height: 15,),
                  // Aboyt
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ));
                      },
                      dense: true,
                      leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle
                        ),
                        child:  Icon(Icons.announcement_outlined,size: 22,  color: Theme.of(context).primaryColor,)
                      ),
                      title: Text(AppLocalizations.of(context).trans('about_us'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,size: 18)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color:
                  //       Theme.of(context).hintColor.withOpacity(0.15),
                  //       offset: Offset(0, 3),
                  //       blurRadius: 10)
                  // ],
                ),
                child:  InkWell(
                  onTap: () async {
                    LocalStorageService.instance.user = null;
                    LocalStorageService.instance.selectedAddress = null;

                    await FirebaseAuth.instance.signOut();
                    Application.restartApp(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // Icon(
                      //   Icons.exit_to_app_sharp,
                      //   color: Colors.red,
                      //   size: 25,
                      //   //  color: Theme.of(context).focusColor.withOpacity(1),
                      // ),
                     // SizedBox(width: 10,),
                      Text(AppLocalizations.of(context).trans('logout'),
                          style: TextStyle(color: Colors.red,fontSize: 22)
                      ),
                    ],
                  ),
                )
            ),


          ],
        ),
      ),
    ):
   GuestProfile();
  }
}
