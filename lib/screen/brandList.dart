
// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/Widgets/BackArrowWidget.dart';
import 'package:onlineshopping/Widgets/empty.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/productDetails.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

class BrandList extends StatefulWidget {
  final String brandID;
  final brandName;
  BrandList(this.brandID, this.brandName, {Key key}) : super(key: key);

  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  List<DocumentSnapshot> productListSnapShot;

  // int favLength;
  List<QueryDocumentSnapshot>  productList=[];
  getProducts() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('products')
        .where('brand',isEqualTo: widget.brandID)
        .get()
        .then((value) {
      productListSnapShot = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          productListSnapShot[i] = element;
          productList.add(element);
          // favLength=productListSnapShot.length;
        });
        i++;

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      appBar:
      AppBar(
        title: Text(widget.brandName),
        elevation: 0,
        leading: BackArrowWidget(),
      ),

      body:  (productListSnapShot == null || productListSnapShot.isEmpty)
          ? EmptyWidget()
          : SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              // crossAxisSpacing: 1,
              // mainAxisSpacing: 1,
              //childAspectRatio: 0.8,
              //childAspectRatio: 0.60, // (itemWidth/itemHeight),
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: MediaQuery.of(context).orientation ==
                  Orientation.portrait
                  ? 2
                  : 4,
              children:
              List.generate(productListSnapShot.length, (index) {
                DocumentSnapshot data= productListSnapShot.elementAt(index);
                return  InkWell(
                  onTap: (){
                    // print('Main Category ID  ${data.id.toString()}');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetails( data.id.toString()),
                    ));

                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(15)
                              //                 <--- border radius here
                            ),
                            border: Border.all(color: Colors.black12,width: 0.6),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    data['images'][0].toString()))),
                      ),
                      SizedBox(height: 7,),
                      Text(
                        AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                        data['nameK'].toString():
                        AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                        data['nameA'].toString():
                        data['name'].toString(),
                        style: TextStyle(fontWeight: FontWeight.w600,),)
                    ],
                  ),
                );
              }),
            ),
          )



      ),



    );
  }
}
