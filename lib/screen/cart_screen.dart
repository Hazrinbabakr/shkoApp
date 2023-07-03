// ignore_for_file: file_names, prefer_const_constructors
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/CustomAppButton.dart';
import 'package:shko/Widgets/empty.dart';
import 'package:shko/Widgets/text-field.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/models/voucher.dart';
import 'package:shko/screen/address/addresses_bottom_sheet.dart';
import 'package:shko/screen/homepage.dart';
import 'package:shko/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';



class CartScreen extends StatefulWidget {
  final bool arrow;
  const CartScreen(this.arrow, {Key? key}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot>? cart;
  List<Map> cartList = [];
  double subTotal=0.0;
  Map<String,dynamic>? adminInfo;
  DocumentSnapshot? adminInfoCollection;
  Map<String,dynamic>? userInfo;
  DocumentSnapshot? userInfoCollection;
  double deliveryFee=0.0;
  //double dinnar =00;
  String name='';
  String address='';
  String phone='';
  var uuid = Uuid();
  String? rundomNumber;
  var formatter = NumberFormat('#,###,000');


  TextEditingController voucherController = TextEditingController();
  Voucher? voucher;

  getCart() {
    cart = [];
    cartList=[];
    subTotal=0.0;
    int i = 0;
    FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('cart').get().then((value) {
      value.docs.forEach((element) async {
        setState(() {
          cart!.add(element);
          cartList.add({
            'name':  cart![i]['name'],
            'price':  cart![i]['price'],
            'productID':  cart![i]['productID'],
            'quantity':  cart![i]['quantity'],
            'img':  cart![i]['img'],
          });
          setState(() {
            subTotal += cart![i]['price']*cart![i]['quantity'];
          });
        });
        i++;
      });
    }).whenComplete(() {

    });

  }

  bool loading = false;


  getVoucher() async {
    print("getVoucher");
   try {
     loading = true;
     setState(() {

     });
      print(voucherController.text.trim().toLowerCase());
      var res = await FirebaseFirestore.instance
          .collection("vouchers")
          .where("voucher",isEqualTo: voucherController.text.trim().toLowerCase())
          .get();

      if (res.size > 0) {

        var usedOrders = await FirebaseFirestore.instance
            .collection("Admin/admindoc/orders")
            .where("voucherId",isEqualTo: res.docs.first.id)
            .where("userID",isEqualTo: user!.uid)
            .get();
        usedOrders.size;

        voucher = Voucher.fromJson(res.docs.first);
        if( usedOrders.size >= voucher!.limit
            || voucher!.expiryDate.difference(DateTime.now()).inSeconds < 0 ){
          voucher = null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans("couponExpired"),style: TextStyle(fontSize: 18),)));
        }
        loading = false;
        setState(() {

        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans("couponInvaild"),style: TextStyle(fontSize: 18),)));
        loading = false;
        setState(() {

        });
      }
     }catch (error){
     loading = false;
     setState(() {

     });
     }
  }
  getAdminInfo() async{
    adminInfoCollection = await FirebaseFirestore.instance
        .collection('Admin').doc('admindoc')
        .get();
    setState(() {
      adminInfo=adminInfoCollection!.data() as Map<String,dynamic>;
      deliveryFee =  double.parse('${adminInfo!['deliveryfee']}');
     // dinnar =  double.parse('${adminInfo.data()['dinnar']}');
    });
  }
  getUserInfo() async{
    userInfoCollection = await FirebaseFirestore.instance
        .collection('users').doc(user!.uid)
        .get();
    setState(() {
      userInfo=userInfoCollection!.data() as Map<String,dynamic>;
      name =  userInfo!['username'];
      address =  userInfo!['address'];
      phone =  userInfo!['phone'];
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
    getAdminInfo();
    getUserInfo();
    rundomNumber = uuid.v1();
   // parseTimeStamp();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:  Text(AppLocalizations.of(context).trans("CartScreen"),style: TextStyle(color: Colors.black87),),
            elevation: 0,
            //leading: BackArrowWidget()
          automaticallyImplyLeading: widget.arrow,
          iconTheme: IconThemeData(color: Colors.black87),

        ),
        body:
        Builder(
            builder: (BuildContext context){
              return cartList.isEmpty || subTotal ==0?


              Center(
                child: Container(
                    height: 280,
                    width: 240,
                    child: Column(
                      children: [
                        Image.asset('images/category/emptyCart.png',),
                        Text(AppLocalizations.of(context).trans("cartIsEmpty"),style: TextStyle(color: Colors.grey[700]),)
                      ],
                    )),
              ):


              ModalProgressHUD(
                inAsyncCall: loading,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: () async {
                                await AddressesBottomSheet.show(context);
                                setState(() {

                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).trans("Address"),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Expanded(
                                    child: Text(
                                      LocalStorageService.instance.selectedAddress?.title??AppLocalizations.of(context).trans("not_selected"),
                                      style: TextStyle(color: Colors.indigo,fontSize: 16),
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart').snapshots(),
                            builder: ( _, snapshot) {
                              return Container(
                                // color: Colors.red,
                                child: ListView.builder(
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (_, index) {

                                    if (snapshot.hasData) {
                                      DocumentSnapshot cartInfo = snapshot.data!.docs[index];


                                      return  InkWell(
                                        onTap: (){
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 20),
                                          child: SingleChildScrollView(
                                            child: Stack(
                                              children: [

                                                Container(
                                                    height: 115,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white70,
                                                        // color: Colors.red,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey[200]!,
                                                              spreadRadius: 1,
                                                              blurRadius: 10)
                                                        ]),
                                                    child:
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)
                                                                  //                 <--- border radius here
                                                                ),
                                                                border: Border.all(color: Colors.black12,width: 0.6),
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: NetworkImage(
                                                                      cartInfo["img"]
                                                                          .toString(),))),
                                                          ),

                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                              child: Container(
                                                                //  color: Colors.red,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [

                                                                    Text(
                                                                      cartInfo["name"]
                                                                          .toString(),
                                                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                                                                      maxLines: 1,
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    // Text(
                                                                    //     '${ cartInfo
                                                                    //         .data()["price"]
                                                                    //         .toString()}\$'
                                                                    // ),

                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [

                                                                        Row(
                                                                          children: [
                                                                            cartInfo["quantity"]
                                                                                .toString()=="1"?
                                                                            InkWell(
                                                                              onTap:  () {
                                                                                showDialog(context:context,
                                                                                  builder: (_)=>  AlertDialog(title: Text('Are You Sure?'),
                                                                                    // shape: CircleBorder(),
                                                                                    shape: BeveledRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(5.0),
                                                                                    ),
                                                                                    elevation: 30,
                                                                                    backgroundColor: Colors.white,
                                                                                    actions: <Widget>[

                                                                                      InkWell(
                                                                                          onTap:(){
                                                                                            Navigator.of(context).pop();
                                                                                          },

                                                                                          child: Text('No',style: TextStyle(fontSize: 20,color: Colors.red[900]),)),
                                                                                      SizedBox(height: 30,),
                                                                                      InkWell(
                                                                                        onTap: (){
                                                                                          setState(() {
                                                                                            //productListSnapShot[i]['quantity']-1;
                                                                                            subTotal -= cartInfo['price'];
                                                                                            User user = _auth.currentUser!;
                                                                                            userCollection
                                                                                                .doc(user.uid)
                                                                                                .collection('cart')
                                                                                                .doc(cartInfo.id).delete();

                                                                                            Navigator.of(context).pop();

                                                                                          });
                                                                                        },
                                                                                        child: Text('Yes',style: TextStyle(fontSize: 20,color: Colors.green[900])),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                                //Addtocart
                                                                              },

                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context)
                                                                                        .primaryColor,
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        100),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.4),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 7,
                                                                                        //offset: Offset(1, 0),
                                                                                      ),
                                                                                    ],
                                                                                  ),

                                                                                  height: 35,
                                                                                  width: 35,
                                                                                  // color: Colors.red,
                                                                                  child:  Icon(
                                                                                    Icons.delete_outline_sharp,
                                                                                    size: 25,
                                                                                    color: Colors.grey,
                                                                                  )
                                                                              ),
                                                                            ):
                                                                            InkWell(
                                                                              onTap:  () {
                                                                                //Addtocart
                                                                                setState(() {
                                                                                  if(  cartInfo['quantity']>1){
                                                                                    //productListSnapShot[i]['quantity']-1;
                                                                                    subTotal -= cartInfo['price'];
                                                                                    User user = _auth.currentUser!;
                                                                                    userCollection
                                                                                        .doc(user.uid)
                                                                                        .collection('cart')
                                                                                        .doc(cartInfo.id).update({
                                                                                      "quantity":  cartInfo['quantity']-1,
                                                                                      // "subPrice": (cartInfo.data()['quantity'] -1) * cartInfo.data()['price']

                                                                                    });

                                                                                    print('removed');
                                                                                  }
                                                                                });
                                                                              },

                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context)
                                                                                        .primaryColor,
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        100),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.4),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 7,
                                                                                        //offset: Offset(1, 0),
                                                                                      ),
                                                                                    ],
                                                                                  ),

                                                                                  height: 35,
                                                                                  width: 35,
                                                                                  // color: Colors.red,
                                                                                  child:  Icon(
                                                                                    Icons.remove,
                                                                                    size: 25,
                                                                                   // color: Colors.grey,
                                                                                  )
                                                                              ),
                                                                            ),


                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                              child: Container(
                                                                                  // decoration: BoxDecoration(
                                                                                  //   border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                                                                                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  //   color: Colors.white,
                                                                                  //
                                                                                  //   boxShadow: [
                                                                                  //     BoxShadow(
                                                                                  //       color: Colors.grey
                                                                                  //           .withOpacity(0.4),
                                                                                  //       spreadRadius: 1,
                                                                                  //       blurRadius: 7,
                                                                                  //       //offset: Offset(1, 0),
                                                                                  //     ),
                                                                                  //   ],
                                                                                  // ),

                                                                                  height: 32,
                                                                                  width: 32,
                                                                                  // color: Colors.red,
                                                                                  child:  Center(child:
                                                                                  Text(cartInfo["quantity"]
                                                                                      .toString(),style: TextStyle(fontSize: 18),))
                                                                              ),
                                                                            ),
                                                                            cartInfo!['availableQuantity']<= cartInfo["quantity"]?
                                                                            InkWell(
                                                                              onTap: (){
                                                                               print("Not Available");
                                                                              },
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context)
                                                                                        .primaryColor,
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(100),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.4),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 7,
                                                                                        //offset: Offset(1, 0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  height: 35,
                                                                                  width: 35,
                                                                                  // color: Colors.red,
                                                                                  child:  Icon(
                                                                                    Icons.add,
                                                                                    size: 25,
                                                                                    color: Colors.grey,
                                                                                  )
                                                                              ),
                                                                            ):

                                                                            InkWell(
                                                                              onTap: (){
                                                                                setState(() {
                                                                                  subTotal += cartInfo['price'];
                                                                                  User user = _auth.currentUser!;
                                                                                  userCollection
                                                                                      .doc(user.uid)
                                                                                      .collection('cart')
                                                                                      .doc(cartInfo.id).update({
                                                                                    "quantity":  cartInfo['quantity']+1,
                                                                                    // "subPrice": (cartInfo.data()['quantity'] +1) * cartInfo.data()['price']
                                                                                  });
                                                                                  //calculatingTotalPrice(cartInfo.data()['price'], cartInfo.data()['quantity']);
                                                                                  print('added');
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Theme.of(context)
                                                                                        .primaryColor,
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(100),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.4),
                                                                                        spreadRadius: 1,
                                                                                        blurRadius: 7,
                                                                                        //offset: Offset(1, 0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  height: 35,
                                                                                  width: 35,
                                                                                  // color: Colors.red,
                                                                                  child:  Icon(
                                                                                    Icons.add,
                                                                                    size: 25,
                                                                                    color: Theme.of(context).colorScheme.secondary,
                                                                                  )
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          '${  formatter.format( (cartInfo["price"]* cartInfo['quantity']))
                                                                              .toString()} IQD',

                                                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),


                                                                        ),
                                                                      ],
                                                                    ),


                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],),
                                                    )
                                                ),
                                                // Positioned(
                                                //   bottom: 15,
                                                //   right: 15,
                                                //   child: Row(
                                                //     children: [
                                                //
                                                //       InkWell(
                                                //         onTap: (){
                                                //           setState(() {
                                                //             subTotal += cartInfo.data()['price'];
                                                //             User user = _auth.currentUser;
                                                //             userCollection
                                                //                 .doc(user.uid)
                                                //                 .collection('cart')
                                                //                 .doc(cartInfo.id).update({
                                                //               "quantity":  cartInfo.data()['quantity']+1,
                                                //               // "subPrice": (cartInfo.data()['quantity'] +1) * cartInfo.data()['price']
                                                //             });
                                                //             //calculatingTotalPrice(cartInfo.data()['price'], cartInfo.data()['quantity']);
                                                //             print('added');
                                                //           });
                                                //
                                                //
                                                //         },
                                                //         child: Container(
                                                //             decoration: BoxDecoration(
                                                //               color: Theme.of(context)
                                                //                   .primaryColor,
                                                //               borderRadius:
                                                //               BorderRadius.circular(
                                                //                   10),
                                                //               boxShadow: [
                                                //                 BoxShadow(
                                                //                   color: Colors.grey
                                                //                       .withOpacity(0.4),
                                                //                   spreadRadius: 1,
                                                //                   blurRadius: 7,
                                                //                   //offset: Offset(1, 0),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //
                                                //             height: 30,
                                                //             width: 30,
                                                //             // color: Colors.red,
                                                //             child:  Icon(
                                                //               Icons.add,
                                                //               size: 23,
                                                //               color: Theme.of(context).accentColor,
                                                //             )
                                                //         ),
                                                //       ),
                                                //       Padding(
                                                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                                                //         child: Container(
                                                //             decoration: BoxDecoration(
                                                //               border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                                                //               borderRadius: BorderRadius.all(Radius.circular(10)),
                                                //               color: Colors.white,
                                                //
                                                //               boxShadow: [
                                                //                 BoxShadow(
                                                //                   color: Colors.grey
                                                //                       .withOpacity(0.4),
                                                //                   spreadRadius: 1,
                                                //                   blurRadius: 7,
                                                //                   //offset: Offset(1, 0),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //
                                                //             height: 32,
                                                //             width: 32,
                                                //             // color: Colors.red,
                                                //             child:  Center(child:
                                                //             Text(cartInfo
                                                //                 .data()["quantity"]
                                                //                 .toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),))
                                                //         ),
                                                //       ),
                                                //
                                                //       cartInfo
                                                //           .data()["quantity"]
                                                //           .toString()=="1"?
                                                //       InkWell(
                                                //         onTap:  () {
                                                //           showDialog(context:context,
                                                //             builder: (_)=>  AlertDialog(title: Text('Are You Sure?'),
                                                //               // shape: CircleBorder(),
                                                //               shape: BeveledRectangleBorder(
                                                //                 borderRadius: BorderRadius.circular(5.0),
                                                //               ),
                                                //               elevation: 30,
                                                //               backgroundColor: Colors.white,
                                                //               actions: <Widget>[
                                                //
                                                //                 InkWell(
                                                //                     onTap:(){
                                                //                       Navigator.of(context).pop();
                                                //                     },
                                                //
                                                //                     child: Text('No',style: TextStyle(fontSize: 20,color: Colors.red[900]),)),
                                                //                 SizedBox(height: 30,),
                                                //                 InkWell(
                                                //                   onTap: (){
                                                //                     setState(() {
                                                //                       //productListSnapShot[i]['quantity']-1;
                                                //                       subTotal -= cartInfo.data()['price'];
                                                //                       User user = _auth.currentUser;
                                                //                       userCollection
                                                //                           .doc(user.uid)
                                                //                           .collection('cart')
                                                //                           .doc(cartInfo.id).delete();
                                                //
                                                //                       Navigator.of(context).pop();
                                                //
                                                //                     });
                                                //                   },
                                                //                   child: Text('Yes',style: TextStyle(fontSize: 20,color: Colors.green[900])),
                                                //                 )
                                                //               ],
                                                //             ),
                                                //           );
                                                //           //Addtocart
                                                //         },
                                                //
                                                //         child: Container(
                                                //             decoration: BoxDecoration(
                                                //               color: Theme.of(context)
                                                //                   .primaryColor,
                                                //               borderRadius:
                                                //               BorderRadius.circular(
                                                //                   10),
                                                //               boxShadow: [
                                                //                 BoxShadow(
                                                //                   color: Colors.grey
                                                //                       .withOpacity(0.4),
                                                //                   spreadRadius: 1,
                                                //                   blurRadius: 7,
                                                //                   //offset: Offset(1, 0),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //
                                                //             height: 30,
                                                //             width: 30,
                                                //             // color: Colors.red,
                                                //             child:  Icon(
                                                //               Icons.delete,
                                                //               size: 25,
                                                //               color: Theme.of(context).accentColor,
                                                //             )
                                                //         ),
                                                //       ):
                                                //
                                                //
                                                //       InkWell(
                                                //         onTap:  () {
                                                //           //Addtocart
                                                //           setState(() {
                                                //             if(  cartInfo.data()['quantity']>1){
                                                //               //productListSnapShot[i]['quantity']-1;
                                                //               subTotal -= cartInfo.data()['price'];
                                                //               User user = _auth.currentUser;
                                                //               userCollection
                                                //                   .doc(user.uid)
                                                //                   .collection('cart')
                                                //                   .doc(cartInfo.id).update({
                                                //                 "quantity":  cartInfo.data()['quantity']-1,
                                                //                 // "subPrice": (cartInfo.data()['quantity'] -1) * cartInfo.data()['price']
                                                //
                                                //               });
                                                //
                                                //               print('removed');
                                                //             }
                                                //           });
                                                //         },
                                                //
                                                //         child: Container(
                                                //             decoration: BoxDecoration(
                                                //               color: Theme.of(context)
                                                //                   .primaryColor,
                                                //               borderRadius:
                                                //               BorderRadius.circular(
                                                //                   10),
                                                //               boxShadow: [
                                                //                 BoxShadow(
                                                //                   color: Colors.grey
                                                //                       .withOpacity(0.4),
                                                //                   spreadRadius: 1,
                                                //                   blurRadius: 7,
                                                //                   //offset: Offset(1, 0),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //
                                                //             height: 30,
                                                //             width: 30,
                                                //             // color: Colors.red,
                                                //             child:  Icon(
                                                //               Icons.remove,
                                                //               size: 25,
                                                //               color: Theme.of(context).accentColor,
                                                //             )
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),);
                                    } else {
                                      return EmptyWidget();
                                    }
                                  },
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      controller: voucherController,
                                      hint: AppLocalizations.of(context).trans("enterCoupon"),
                                    ),
                                  ),
                                  SizedBox(width: 12,),
                                  SizedBox(
                                    width: 90,
                                    height: 50,
                                    child: CustomAppButton(
                                      color: voucher == null ? Theme.of(context).colorScheme.secondary:Colors.red,
                                      elevation: 0,
                                      borderRadius: 8,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context).trans(voucher == null?AppLocalizations.of(context).trans("apply"):AppLocalizations.of(context).trans("remove")),style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                      onTap: (){
                                        if(voucher != null){
                                          voucherController.text = '';
                                          voucher = null;
                                          setState(() {

                                          });
                                        }
                                        else{
                                          if(voucherController.text.trim().isNotEmpty){
                                            getVoucher();
                                          }
                                        }

                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 12,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context).trans("subtotal"),
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
                                ),
                                Text('${formatter.format(subTotal.floor()).toString()} IQD',
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            if(voucher != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppLocalizations.of(context).trans("discount"),
                                        style: TextStyle(fontSize: 14,),

                                      ),
                                      Text('${deliveryFee != 0 ? "-":""}${formatter.format(getDiscount)} IQD',
                                        style: TextStyle(fontSize: 14,color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppLocalizations.of(context).trans("discounted_price"),
                                        style: TextStyle(fontSize: 14,),

                                      ),
                                      Text('${formatter.format(finalSubTotal)} IQD',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 2,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context).trans("DeliveryFee"),
                                  style: TextStyle(fontSize: 14,),

                                ),
                                Text('${formatter.format(deliveryFee.floor())} IQD',
                                  style: TextStyle(fontSize: 14,),
                                ),
                              ],
                            ),
                            //SizedBox(height: 10,),
                            Divider(
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context).trans("total"),
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                                Text('${formatter.format(((finalSubTotal+deliveryFee)).floor()).toString()} IQD',
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('Today\'s Exchange Rate',
                            //       style: TextStyle(fontSize: 13,),
                            //
                            //     ),
                            //     Text('${(dinnar*100).floor().toString()} IQD',
                            //       style: TextStyle(fontSize: 13,),
                            //     ),
                            //   ],
                            // ),



                            SizedBox(height: 15,),
                            InkWell(
                                onTap: (){
                                  if(LocalStorageService.instance.selectedAddress == null){
                                    Fluttertoast.showToast(msg: AppLocalizations.of(context).trans("please_select_address"));
                                    return;
                                  }
                                  setState(() {
                                    var date =  DateTime.now();
                                    var orderDate = DateFormat('MM-dd-yyyy, hh:mm a').format(date);

                                    // cartList.add({
                                    //   'name': snapshot.data.docs[index]['name'],
                                    //   'price': snapshot.data.docs[index]['price'],
                                    //   'quantity': snapshot.data.docs[index]['quantity'],
                                    // });

                                    getCart();
                                    Future.delayed(Duration(milliseconds: 100),(){
                                      FirebaseFirestore.instance.collection('Admin')
                                          .doc('admindoc')
                                          .collection('orders').doc(rundomNumber)
                                          .set({
                                        "productList":cartList,
                                        "subTotal": subTotal,
                                        "totalPrice":(subTotal+deliveryFee),
                                        "deliveryFee":deliveryFee,
                                        "userID": user!.uid,
                                        "userName": name,
                                        "userAddress": LocalStorageService.instance.selectedAddress!.title,
                                        "userLat": LocalStorageService.instance.selectedAddress!.latitude,
                                        "userLong": LocalStorageService.instance.selectedAddress!.longitude,
                                        "userDesc": LocalStorageService.instance.selectedAddress!.description,
                                        "userPhone": phone,
                                        "orderID":rundomNumber,
                                        "OrderStatus": 'Pending',
                                        "date": orderDate,
                                        "voucherId":voucher?.id,
                                        "voucher":voucher?.voucher,
                                        "voucherType":voucher?.type.name,
                                        "voucherValue":voucher?.value
                                      });

                                      FirebaseFirestore.instance.collection('users')
                                          .doc(user!.uid).collection('orders').doc(rundomNumber).set({
                                        "productList":cartList,
                                        "subTotal": finalSubTotal,
                                        "totalPrice":(finalSubTotal+deliveryFee),
                                        "deliveryFee":deliveryFee,
                                        "userID": user!.uid,
                                        "userName": name,
                                        "userAddress": LocalStorageService.instance.selectedAddress!.title,
                                        "userLat": LocalStorageService.instance.selectedAddress!.latitude,
                                        "userLong": LocalStorageService.instance.selectedAddress!.longitude,
                                        "userDesc": LocalStorageService.instance.selectedAddress!.description,
                                        "userPhone": phone,
                                     //   "dinnar": dinnar,
                                        "orderID":rundomNumber,
                                        "OrderStatus": 'Pending',
                                        "date": orderDate,
                                        "voucherId":voucher?.id,
                                        "voucher":voucher?.voucher,
                                        "voucherType":voucher?.type.name,
                                        "voucherValue":voucher?.value
                                      });

                                    }).whenComplete(() {
                                      ScaffoldMessenger.of(context).showSnackBar(_snackBar);

                                      Future.delayed(Duration(seconds: 2),(){
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ));

                                        FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('cart')
                                            .get().then((snapshot) {
                                          for (DocumentSnapshot doc in snapshot.docs) {
                                            doc.reference.delete();
                                          }
                                        });

                                        print('done');
                                      });



                                    });
// OrderHistoryScreen
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)
                                      //                 <--- border radius here
                                    ),),
                                  width: double.infinity,

                                  padding: EdgeInsets.all(15),

                                  margin: EdgeInsets.only(left: 75,right: 75,bottom: 5),
                                  child: Center(child: Text(AppLocalizations.of(context).trans("Sendorder"),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),)),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              );
            }
        )



    );
  }
  final _snackBar = SnackBar(
    content: Text(
      'You order has been placed',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 2),
  );

  get finalSubTotal {
    if(voucher != null){
      Voucher currentVoucher = voucher!;
      if(currentVoucher.type == VoucherType.percent){
        return subTotal - (subTotal * (currentVoucher.value/100));
      }
      else {
        return max(0,subTotal - currentVoucher.value);
      }
    }else {
      return subTotal;
    }
  }

  get getDiscount {
    if(voucher != null){
      Voucher currentVoucher = voucher!;
      if(currentVoucher.type == VoucherType.percent){
        return (subTotal * (currentVoucher.value/100));
      }
      else {
        return min(subTotal, currentVoucher.value);
      }
    }
    return 0;
  }

// getAllProduct() {
//   allProductListSnapShot = new List<DocumentSnapshot>(productListSnapShot.length);
//  // allProductList = new List<Map>(productListSnapShot.length);
//   for(int i=0; i<productListSnapShot.length;i++) {
//
//     FirebaseFirestore.instance
//         .collection('products').where("productID", isEqualTo: productListSnapShot[i].id)
//         .get()
//         .then((value) {
//       value.docs.forEach((element) async {
//         setState(() {
//           allProductListSnapShot[i] =  element;
//           price=    allProductListSnapShot[i]['retail price'] *  productListSnapShot[i]['quantity'];
//          // name= allProductListSnapShot[i]['name'];
//
//           // allProductList.add({
//           //   "name":  allProductListSnapShot[i]['name']
//           // });
//
//         });
//         i++;
//       });
//     }).whenComplete(() {
//       calculatingTotalPrice();
//     });
//   }
// }

}







//



// calculatingTotalPrice(int price, int quantity){
//   setState(() {
//     for (int index = 0; index <  2; index++) {
//       totalPrice =  price * quantity ;
//     }
//   });
// }
