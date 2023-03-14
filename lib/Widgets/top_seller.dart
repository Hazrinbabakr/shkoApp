
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
          Text(AppLocalizations.of(context).trans("topSeller"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),),
          SizedBox(height: 15,),
          Container(
            // color: Colors.red,
            // width: 200,
            height: 270,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)
                                  //                 <--- border radius here
                                ),
                                border: Border.all(color: Colors.black12,width: 0.6),
                                image: DecorationImage(
                                  // fit: BoxFit.cover,
                                    image: NetworkImage(
                                        topSellerSnapshot[i]['images'][0].toString()
                                    )
                                )),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 30,
                                //color: Colors.grey,
                                child: Center(
                                  child: Text(

                                    AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                    topSellerSnapshot[i]['nameK'].toString():
                                    AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                    topSellerSnapshot[i]['nameA'].toString():
                                    topSellerSnapshot[i]['name'].toString(),

                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,), overflow: TextOverflow.ellipsis,),
                                ),
                              ),
                              //  SizedBox(height: 10,),
                              Text('${ topSellerSnapshot[i]['price'].toString()}\$',
                                style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10,),

                            ],
                          )
                        ],
                      ),
                    ),)
                      : SizedBox();
                }),
          ),
        ],
      );
  }
}
