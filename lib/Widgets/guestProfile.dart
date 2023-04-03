// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/Widgets/language_bottom_sheet.dart';
import 'package:onlineshopping/app/Application.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/Favorites.dart';
import 'package:onlineshopping/screen/about_us.dart';
import 'package:onlineshopping/screen/address/addresses_list.dart';
import 'package:onlineshopping/screen/auth/normal_user_login/login_main_page.dart';
import 'package:onlineshopping/screen/order_history.dart';
import 'package:onlineshopping/services/local_storage_service.dart';




class GuestProfile extends StatefulWidget {
  const GuestProfile({Key key}) : super(key: key);
  @override
  _GuestProfileState createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {




  @override
  Widget build(BuildContext context) {
    return
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
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:  Row(
                        children: [
                          Image.asset('images/category/profile.png',width: 70,color:Theme.of(context).accentColor,),
                          SizedBox(width: 10,),
                          Text('Name',style: TextStyle(fontSize: 17),),
                        ],
                      ),
                    ),

                    // SizedBox(width: 2,),
                  ],
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

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MainLoginPage(),
                    ));

                  },
                  child: Center(
                    child: Text(AppLocalizations.of(context).trans('Signin'),
                        style: TextStyle(color: Colors.red,fontSize: 22)
                    ),
                  ),
                )
            ),


          ],
        ),
      ),
    );
  }
}
