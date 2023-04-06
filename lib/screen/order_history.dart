// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/empty.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productDetails.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<DocumentSnapshot> orderHistoryList;
  List<DocumentSnapshot> currentOrderList;
  FirebaseAuth _auth;
  User user;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final adminCollection = FirebaseFirestore.instance.collection('Admin');
  getProducts() {
    int i = 0;
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('orders').
    where("OrderStatus",isNotEqualTo: "Pending")
        .get()
        .then((value) {
      orderHistoryList = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          orderHistoryList[i] = element;
        });
        i++;
      });
    }).whenComplete(() {
     // print(orderHistoryList.length);
    });
  }

  getCurrentProducts() {
    int i = 0;
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('orders').
        orderBy('date', descending: true)
   // where("OrderStatus",isEqualTo: "Pending")
        .get()
        .then((value) {
      currentOrderList = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          currentOrderList[i] = element;
          length= currentOrderList.length;
        });
        i++;
      });
    }).whenComplete(() {
      // print(currentOrderList.length);
    });
  }


int length=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth= FirebaseAuth.instance;
    user=_auth.currentUser;
    getProducts();
    getCurrentProducts();
  }


  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3, // length of tabs
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            bottom:  PreferredSize(

              preferredSize: Size.fromHeight(40),
              child: Container(
               // color: Colors.red,
                height: 40,
                width: double.infinity,
                // padding: const EdgeInsets.symmetric(
                //   horizontal: 20,
                //   vertical: 5,
                // ),
                child: TabBar(
                 // indicatorWeight: 3,
                  isScrollable: false,

                  labelColor:  Colors.white,
                  unselectedLabelColor: Colors.grey[700],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).accentColor,
                  ),
                  //indicatorPadding: EdgeInsets.all(90),
                  onTap: (index){
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  tabs: [
                    Tab(text:

                      AppLocalizations.of(context).trans("processing"),
                    ),
                    Tab(text:
                       AppLocalizations.of(context).trans("Accepted"),
                    ),
                    Tab(text:

                       AppLocalizations.of(context).trans("canceled"),
                    ),
                  ],
                ),
              ),
            ),
           // automaticallyImplyLeading: false,
              title: Text(AppLocalizations.of(context).trans("orders"),),
              elevation: 0,
          ),
          body:
         SingleChildScrollView(
           child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[

                 Container(
                     decoration: BoxDecoration(
                         border: Border(
                             top: BorderSide(
                                 color: Colors.grey,
                                 width: 0.5))),
                     child: Padding(
                         padding:
                         const EdgeInsets.all(15.0),
                         child: getCurrentPage()
                     ))
               ]),
         )
      ),
    );
  }

  
  
  
  
  
  int selectedIndex = 0;
  getCurrentPage(){
    if(selectedIndex == 0){
      return
        ((currentOrderList == null) & (orderHistoryList == null))?
        EmptyWidget():
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //currentttt
            (length==0)
                ? SizedBox()
                : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentOrderList.length,
                      itemBuilder: (context, i) {
                        return (currentOrderList[i] != null) && currentOrderList[i]['OrderStatus'] == "Pending"?

                        ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              // height: 175,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          spreadRadius: 1,
                                          blurRadius: 10)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                           AppLocalizations.of(context).trans(currentOrderList[i]['OrderStatus'])
                                          //  "Pending"

                                            ,style: TextStyle(color: Colors.orange,fontSize: 18),),
                                          InkWell(
                                            onTap: (){
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

                                                        child: Text('No',style: TextStyle(fontSize: 20,color: Colors.red[900]),)
                                                    ),
                                                    SizedBox(height: 30,),
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {

                                                          User user = _auth.currentUser;
                                                          userCollection
                                                              .doc(user.uid)
                                                              .collection('orders')
                                                              .doc(currentOrderList[i].id).delete();
                                                          adminCollection
                                                              .doc('admindoc')
                                                              .collection('orders')
                                                              .doc(currentOrderList[i].id).delete();

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
                                            child: Text(
                                             // 'داواکارییەکەم هەڵبوەشێنەرەوە'
                                              AppLocalizations.of(context).trans('cancelMyOrder')
                                              //  "Pending"

                                              ,style: TextStyle(color:Colors.red[700],fontSize: 16),),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:7 ),
                                        child: Text(currentOrderList[i]['date'],style: TextStyle(fontSize: 12,color: Colors.black),),
                                      ),
                                      Row(
                                        children: [
                                          Text( AppLocalizations.of(context).trans("deliveryTo"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                          Expanded(child: Text(currentOrderList[i]['userAddress'].toString(),style: TextStyle(color: Colors.black),)),
                                        ],
                                      ),




                                    ],
                                  ),
                                )),
                          ), children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(children: [
                              Container(
                                height: 60,
                                // color: Colors.red,
                                // margin: EdgeInsets.only(
                                //     left: 15.0),
                                child: ListView.builder(
                                    itemCount: currentOrderList[i][
                                    "productList"]
                                        .length,
                                    itemBuilder:
                                        (context, index) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text('${currentOrderList[i]["productList"][index]['quantity'].toString()}x'),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                    currentOrderList[i]["productList"][index]['name'],
                                                    style:
                                                    TextStyle(fontSize: 14
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5,),

                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Row(
                                children: [
                                  Text( AppLocalizations.of(context).trans("DeliveryFee"),style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text('${currentOrderList[i]['deliveryFee'].toString()}IQD')),
                                ],
                              ),
                              Row(
                                children: [
                                  Text( AppLocalizations.of(context).trans("TotalPrice"),style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text('${currentOrderList[i]['totalPrice'].toString()}IQD')),
                                ],
                              ),


                              SizedBox(height: 10,)

                            ],),
                          )
                        ],
                        )
                            : SizedBox();

                        //EmptyWidget();
                      }),

                ],
              ),
            ),


          ],);
    }
    if(selectedIndex == 1){
      return
        ((currentOrderList == null) & (orderHistoryList == null))?
        EmptyWidget():
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //currentttt
            (length==0)
                ? SizedBox()
                : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentOrderList.length,
                      itemBuilder: (context, i) {
                        return (currentOrderList[i] != null) && currentOrderList[i]['OrderStatus'] == "Accepted"?

                        ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              // height: 175,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          spreadRadius: 1,
                                          blurRadius: 10)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        "Accepted"
                                        //currentOrderList[i]['OrderStatus']
                                        ,style: TextStyle(color: Colors.green[600],fontSize: 18),),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical:7 ),
                                        child: Text(currentOrderList[i]['date'],style: TextStyle(fontSize: 12),),
                                      ),
                                      Row(
                                        children: [
                                          Text('Deliver to: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                          Expanded(child: Text(currentOrderList[i]['userAddress'].toString())),
                                        ],
                                      ),




                                    ],
                                  ),
                                )),
                          ), children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(children: [
                              Container(
                                height: 60,
                                // color: Colors.red,
                                // margin: EdgeInsets.only(
                                //     left: 15.0),
                                child: ListView.builder(
                                    itemCount: currentOrderList[i][
                                    "productList"]
                                        .length,
                                    itemBuilder:
                                        (context, index) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text('${currentOrderList[i]["productList"][index]['quantity'].toString()}x'),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                    currentOrderList[i]["productList"][index]['name'],
                                                    style:
                                                    TextStyle(fontSize: 14
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5,),

                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Row(
                                children: [
                                  Text('Delivery Fee: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text('${currentOrderList[i]['deliveryFee'].toString()}\$')),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Total Price: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text('${currentOrderList[i]['totalPrice'].toString()}\S')),
                                ],
                              ),


                              SizedBox(height: 10,)

                            ],),
                          )
                        ],
                        )
                            : SizedBox();

                        //EmptyWidget();
                      }),

                ],
              ),
            ),
          ],);
    }
    else if (selectedIndex == 2){
      return
        ((currentOrderList == null) & (orderHistoryList == null))?
        EmptyWidget():
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //currentttt
            (length==0)
                ? SizedBox()
                : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentOrderList.length,
                      itemBuilder: (context, i) {
                        return (currentOrderList[i] != null) && currentOrderList[i]['OrderStatus'] == "Rejected"?

                        ExpansionTile(
                          title: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            // height: 175,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200],
                                        spreadRadius: 1,
                                        blurRadius: 10)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cancelled"
                                      //currentOrderList[i]['OrderStatus']
                                      ,style: TextStyle(color: Colors.red[500],fontSize: 18),),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical:7 ),
                                      child: Text(currentOrderList[i]['date'],style: TextStyle(fontSize: 12),),
                                    ),
                                    Row(
                                      children: [
                                        Text('Deliver to: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                        Expanded(child: Text(currentOrderList[i]['userAddress'].toString())),
                                      ],
                                    ),




                                  ],
                                ),
                              )),
                        ), children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(children: [
                                Container(
                                  height: 60,
                                  // color: Colors.red,
                                  // margin: EdgeInsets.only(
                                  //     left: 15.0),
                                  child: ListView.builder(
                                      itemCount: currentOrderList[i][
                                      "productList"]
                                          .length,
                                      itemBuilder:
                                          (context, index) {
                                        return SingleChildScrollView(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text('${currentOrderList[i]["productList"][index]['quantity'].toString()}x'),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      currentOrderList[i]["productList"][index]['name'],
                                                      style:
                                                      TextStyle(fontSize: 14
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),

                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Row(
                                  children: [
                                    Text('Delivery Fee: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                    Expanded(child: Text('${currentOrderList[i]['deliveryFee'].toString()}\$')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Total Price: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                    Expanded(child: Text('${currentOrderList[i]['totalPrice'].toString()}\S')),
                                  ],
                                ),


                                SizedBox(height: 10,)

                              ],),
                            )
                          ],
                        )
                            : SizedBox();

                        //EmptyWidget();
                      }),

                ],
              ),
            ),


          ],);

    }

  }


}



