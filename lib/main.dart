import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shko/app/Application.dart';
import 'package:shko/helper/colors.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/suplashScreen.dart';
import 'package:provider/provider.dart';
import 'localization/kurdish_material_localization.dart';
import 'services/local_storage_service.dart';
import 'services/settings_service_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageService.instance.init();
  var res = FirebaseMessaging.instance;
  res.getToken().then((value) {
    print("value ${value}");
  });
  if(LocalStorageService.instance.languageCode == null){
    LocalStorageService.instance.languageCode = "en";
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) {
        return SettingsServiceProvider();
      },
      child: Application(
        child: Consumer<SettingsServiceProvider>(
          builder: (context,settings,child){
            return MaterialApp(

              debugShowCheckedModeBanner: false,
              //color: Colors.white,
              theme: ThemeData(
                  primaryColor: Colors.white,
                  colorScheme: ColorScheme.light(
                    secondary: Color(0xff00bebb),
                  ),

                  fontFamily: 'NRT',
              ),
              home: SplashScreen(),//SignUpMainPage(),
              builder: (context, child) {
                if (AppLocalizations.of(context).locale.languageCode ==
                    "ku") {
                  child = Directionality(
                      textDirection: TextDirection.rtl, child: child!);
                }
                return child!;
              },
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                KurdishMaterialLocalizations.delegate,
                KurdishCupertinoLocalization.delegate
              ],
              supportedLocales: Lang.values.map((e) => Locale(e)).toList(),
              locale: Locale(LocalStorageService.instance.languageCode??"en"),
              //Test()
            );
          },
        ),
      ),
    );
  }
}


