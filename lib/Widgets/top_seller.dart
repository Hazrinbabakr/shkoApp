
// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/productDetails.dart';
import 'package:onlineshopping/screen/productList.dart';
import 'package:onlineshopping/services/local_storage_service.dart';


class TopSeller extends StatefulWidget {
  const TopSeller({ key}) : super(key: key);

  @override
  _TopSellerState createState() => _TopSellerState();
}

class _TopSellerState extends State<TopSeller> {
  List<DocumentSnapshot> topSellerSnapshot;
  getTopSeller() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('products').where("newArrival", isEqualTo: true)
        .get()
        .then((value) {
      topSellerSnapshot = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          topSellerSnapshot[i] = element;
        });
        i++;
      });
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopSeller();
  }

  @override
  Widget build(BuildContext context) {
    return
      (topSellerSnapshot == null || topSellerSnapshot.isEmpty)
          ? SizedBox()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(AppLocalizations.of(context).trans("topSeller"),style: TextStyle(fontSize: 22),),
              InkWell(
                  onTap: (){
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => AllCategory(categorySnapshot)),
                    // );
                  },
                  child: Text( AppLocalizations.of(context).trans("ShowAll"),style: TextStyle(fontSize: 13,color: Theme.of(context).accentColor),)),

            ],
          ),
          SizedBox(height: 15,),
          Container(
            // color: Colors.red,
            // width: 200,
            height: 230,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: topSellerSnapshot.length,
                itemBuilder: (context, i) {
                  return (topSellerSnapshot[i] != null)
                      ? InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetails( topSellerSnapshot[i].id.toString()),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                              //                 <--- border radius here
                            ),
                            border: Border.all(color: Colors.black12,width: 0.6),
                          ),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                             Container(
                             //  color: Colors.red,
                               height:115,
                               width: 170,
                               child: Image.network(
                        topSellerSnapshot[i]['images'][0].toString()??""
                      ),
                             ),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text('${ topSellerSnapshot[i]['price'].toString()}',
                                        style: TextStyle(fontSize: 19,color: Colors.red[700],fontWeight: FontWeight.w500),),
                                      Text('IQD',
                                        style: TextStyle(fontSize: 13,color: Colors.red[700],fontWeight: FontWeight.w500),),

SizedBox(width: 5,),

                                      Text('${ topSellerSnapshot[i]['oldPrice'].toString()}',
                                        style: TextStyle(fontSize: 10,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                                      Text('IQD',
                                        style: TextStyle(fontSize: 7,color: Colors.grey,decoration: TextDecoration.lineThrough),),

                                    ],
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  height: 30,
                                  //color: Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(

                                      AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                      topSellerSnapshot[i]['nameK'].toString():
                                      AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                      topSellerSnapshot[i]['nameA'].toString():
                                      topSellerSnapshot[i]['name'].toString(),

                                      style: TextStyle(fontSize: 16,), overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                //  SizedBox(height: 10,),

                                SizedBox(height: 10,),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),)
                      : SizedBox();
                }),
          ),
        ],
      );
  }
}
