
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onlineshopping/Widgets/CustomAppButton.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/auth/normal_user_login/login_main_page.dart';
import 'package:onlineshopping/screen/homepage.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

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
      body: SafeArea(
        top: true,
        child: Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8.0),
                child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    //opacity: showButton ? 1 : 0,
                    child: SizedBox(
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                      child: CustomAppButton(
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 0,
                        borderRadius: 18,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).trans("next"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
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
                    )),
              )
            ],
          ),
        ),
      ),
    );
    // return BlocBuilder<AppInitBloc, AppInitState>(builder: (context, state) {
    //
    // });
  }

  List<String> images = [
    "images/board1.png",
    "images/board2.png",
    "images/board3.png",
    "images/board4.png"
  ];

  List<String> text = [
    "onboard_text_1",
    "onboard_text_2",
    "onboard_text_3",
    "onboard_text_4"
  ];

  List<String> subText = [
    "onboard_subtext_1",
    "onboard_subtext_2",
    "onboard_subtext_3",
    "onboard_subtext_4"
  ];

  imageSlider(List<String> images) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.75,
      width: MediaQuery.of(context).size.width,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "${images[index]}",
                    fit: BoxFit.contain,
                    height: height * 0.35,
                    width: width,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).trans(text[index]),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    AppLocalizations.of(context).trans(subText[index]),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.grey
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
