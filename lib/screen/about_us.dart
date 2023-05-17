import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class AboutUs extends StatefulWidget {
  const AboutUs({key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String whatsAppPhone='';
  String phone='';
  Map<String,dynamic>? adminInfo;
  Future getAdminInfo()async{
    adminInfo= (await FirebaseFirestore.instance.collection("Admin").doc('admindoc').get()).data();

    setState(() {
      whatsAppPhone= adminInfo!['whatsappPhone'].toString();
      phone= adminInfo!['phoneNumber'].toString();
    });
  }
  @override
  void initState() {
    getAdminInfo();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(

        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 30,)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    AppLocalizations.of(context).trans("chooseShko"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  // Text('Choose Shko!',
                  //   style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),
                  //   //textAlign: TextAlign.center,
                  // ),
                  //SizedBox(height: 5,),
                  Text(AppLocalizations.of(context).trans("whoIsShko"),
                  style: TextStyle(fontSize: 22),
                    //textAlign: TextAlign.center,
                  ),


                  SizedBox(height: 30,),
                  Text(AppLocalizations.of(context).trans("contact_us"),


                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),
                    //textAlign: TextAlign.center,

                  ),
                  Center(
                    child: Image.asset(
                      'images/category/one.png',
                      height: 50,
                      width: 500,
                      //width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: (){
                            launchUrlString('https://instagram.com/shko_st?igshid=YWJhMjlhZTc=');
                          },
                          child: Image.asset('images/category/location.png',width: 30,)),
                      InkWell(
                          onTap: (){
                            launchUrlString("tel:0${phone.toString()}");
                          },
                          child: Image.asset('images/category/phone.png',
                            width: 30,)),
                      InkWell(
                          onTap: (){
                            launchUrlString(whatsAppPhone.toString());
                          },
                          child: Image.asset('images/category/whatsapp.png',
                            width: 30,)),

                      InkWell(
                          onTap: (){
                            //   print('whatsapp');
                            launchUrlString("https://mobile.facebook.com/Shkocopycenter/?_rdc=1&_rdr&refsrc=deprecated");

                          },
                          child: Image.asset('images/category/fb.png',width: 30,)),
                      InkWell(
                          onTap: (){
                            launchUrlString("https://instagram.com/shko_st?igshid=YWJhMjlhZTc=");
                          },
                          child: Image.asset('images/category/insta.png',width: 30,)),


                      //
                      // InkWell(
                      // onTap: (){
                      //   launch("tel:0${7501440058}");
                      // },
                      // child: Icon(Icons.phone_outlined)),
                    ],),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


