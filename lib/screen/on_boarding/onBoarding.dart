
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shko/Widgets/CustomAppButton.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/auth/normal_user_login/login_main_page.dart';
import 'package:shko/screen/homepage.dart';
import 'package:shko/services/local_storage_service.dart';

import 'widgets/wideDotsSwiperPaginationBuilder.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  bool showButton = false;

  SwiperController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title:Image.asset('images/category/shkoLogo.png',width: 80,),

      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomAppButton(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context).trans("skip"),
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  onTap: goHome,
                )
              ],
            ),
            imageSlider(images),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8.0),
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  //opacity: showButton ? 1 : 0,
                  child: SizedBox(
                    height: 54,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30,),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              goHome();
                               LocalStorageService.instance.firstTime = false;
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              //   return MainLoginPage();
                              // }));
                            },
                            child: Text('Skip',
                              style: TextStyle(
                                fontSize: 22,
                                decoration: TextDecoration.underline,
                                color: Colors.grey[700]
                              ),
                            ),
                          ),
                          SizedBox(width: 140,),
                          Expanded(
                            flex: 2,
                            child: CustomAppButton(
                              color: Color(0xff8dba39),
                              elevation: 0,
                              borderRadius: 15,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).trans("Next"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(

                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (showButton) {
                                  goHome();
                                } else {
                                  _controller.next();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
    // return BlocBuilder<AppInitBloc, AppInitState>(builder: (context, state) {
    //
    // });
  }

  List<String> images = [
    "images/category/onboard3.png",
    "images/category/onboard1.png",
    "images/category/onboard2.png",
  ];

  List<String> text = [
    "Welcome to Shko app",
    "The first app",
    "Enjoy!",
  ];

  List<String> subText = [
    "We are here to serve you",
    "The first stationary app in Kurdistan",
    "We hope that we can be satisfied with you",
  ];

  imageSlider(List<String> images) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.70,
      width: MediaQuery.of(context).size.width,
      //color: Colors.red,
      child: Swiper(
          itemCount: images.length,
          loop: false,
          controller: _controller,
          onIndexChanged: (index) {
            if (index == (images.length - 1)) {
              setState(() {
                showButton = true;
              });
            }
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "${images[index]}",
                    fit: BoxFit.contain,
                    height: height * 0.44,
                    width: width,
                  ),
                  SizedBox(
                    height: 44,
                  ),
                  Text(
                    AppLocalizations.of(context).trans(text[index]),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).trans(subText[index]),
                    style: TextStyle(
                       // fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: Colors.grey,
                      //letterSpacing:
                    ),
                    textAlign: TextAlign.center,

                  ),
                ],
              ),
            );
          },
          pagination: SwiperPagination(
            builder: WideDotsSwiperPaginationBuilder(),
          )),
    );
  }

  goHome() {
    LocalStorageService.instance.firstTime = false;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
      if (FirebaseAuth.instance.currentUser != null )
      {
        return HomePage();
      }
      else {
        return MainLoginPage();
      }
    }));//MainPage
  }
}
