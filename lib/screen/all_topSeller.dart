// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/empty.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productDetails.dart';
import 'package:shko/screen/productList.dart';



class AllTopSeller extends StatefulWidget {
  final List<DocumentSnapshot> topSellerSnapshot;
  const AllTopSeller(this.topSellerSnapshot, {Key? key}) : super(key: key);
  @override
  _AllTopSellerState createState() => _AllTopSellerState();
}

class _AllTopSellerState extends State<AllTopSeller> {
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackArrowWidget(),
           automaticallyImplyLeading: false,
          title: Text(  AppLocalizations.of(context).trans("topSeller"),style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),),
          elevation: 0,
        ),

        body:
        (widget.topSellerSnapshot == null)
            ? EmptyWidget()
            : GridView.count(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,

          crossAxisSpacing: 12,
          //mainAxisSpacing: 15,
          childAspectRatio: 0.85, // (itemWidth/itemHeight),
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 10),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: MediaQuery.of(context).orientation ==
              Orientation.portrait
              ? 2
              : 4,
          children:
          List.generate(widget.topSellerSnapshot.length, (i) {
            //DocumentSnapshot data= widget.topSellerSnapshot.elementAt(i);
            return (widget.topSellerSnapshot[i] != null)
                ? InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetails( widget.topSellerSnapshot[i].id.toString()),
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
                            widget.topSellerSnapshot[i]['images'][0].toString()??""
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
                                Text('${ widget.topSellerSnapshot[i]['price'].toString()}',
                                  style: TextStyle(fontSize: 19,color: Colors.red[700],fontWeight: FontWeight.w500),),
                                Text('IQD',
                                  style: TextStyle(fontSize: 13,color: Colors.red[700],fontWeight: FontWeight.w500),),

                                SizedBox(width: 5,),

                                Text('${ widget.topSellerSnapshot[i]['oldPrice'].toString()}',
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
                                widget.topSellerSnapshot[i]['nameK'].toString():
                                AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                widget.topSellerSnapshot[i]['nameA'].toString():
                                widget.topSellerSnapshot[i]['name'].toString(),

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
        )
    );
  }
}



