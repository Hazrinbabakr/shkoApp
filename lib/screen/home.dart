import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/Categories.dart';
import 'package:shko/Widgets/Offers.dart';
import 'package:shko/Widgets/brands.dart';
import 'package:shko/Widgets/top_seller.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/services/local_storage_service.dart';

import 'address/addresses_bottom_sheet.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //Delivery address widget
                // HomeAppBar(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('images/category/shkoLogo.png',width: 80,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () async {
                          await AddressesBottomSheet.show(context);
                          setState(() {

                          });
                        },
                        child:FirebaseAuth.instance.currentUser != null? Row(
                          children: [
                            Icon(Icons.location_on,color: Colors.red[700],size: 20,),
                            Text(
                              LocalStorageService.instance.selectedAddress?.title??
                                  AppLocalizations.of(context).trans("not_selected"),
                              style: TextStyle(fontSize: 16),
                              maxLines: 2,
                            ),
                          ],
                        ): SizedBox()
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 10,),
                Offers(),
                //Text('tess'),
                 CategoriesWidget(),
                // SizedBox(height: 10,),
                // SocialMediaWidget()
                TopSeller(),
                SizedBox(height: 60,),
                Brands()

              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  // Future sendEmail() async {
  //   final smptServer = gmailSaslXoauth2(email, accessToken)
  //   final email = "hizreen.safaree@gmail.com";
  //   final token='';
  //   final message = Message()
  //     ..from = Address(email, "hizreen")
  //     ..recipients = ['hizreen.safaree@gmail.com']
  //     ..subject='Hello Hizreen'
  //     ..text= 'this is text message';
  //   try {
  //     await send(message, smptServer);
  //   } on MailerException catch (e){
  //     print(e);
  //   }
  // }

  // Future<void> send() async {
  //   final Email email = Email(
  //     body: 'Email body',
  //     subject: 'Email subject',
  //     recipients: ['hizreen.safaree@gmail.com'],
  //     cc: ['hizreen.safaree@gmail.com'],
  //     bcc: ['hizreen.safaree@gmail.com'],
  //     isHTML: false,
  //   );
  //
  //   await FlutterEmailSender.send(email);
  // }
  //
  // Future sendEmail({
  //   required String name,
  //   required String email,
  //   required String subject,
  //   required String message,
  // }) async {
  //   final serviceld= 'service_85hjoxm';
  //   final templateId=  'template_tiadhge';
  //   final userId=  '';
  //
  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //       final response = await http.post(
  //       url,
  //       body: {
  //       'service_id': serviceld,
  //       'template_id'; templateld,
  //       'user id': userId,
  //       },
  //       );

}








// StreamBuilder<QuerySnapshot>(
// stream: FirebaseFirestore.instance.collection('test').snapshots(),
// builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// if (snapshot.hasError) {
// print('Errorrrrr ${snapshot.error}');
// return const Text('Something went wrong');
// }
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const CircularProgressIndicator();
// }
//
// return  Container(
// height: 1000,
//
// child: ListView(
// children: snapshot.data!.docs.map((DocumentSnapshot document) {
// Map<String, dynamic> data = document.data()!;
// return ListTile(
// title: Text('ssss ${data['test1'].toString()}'),
// );
// }).toList(),
// ),
// );
// },
// ),