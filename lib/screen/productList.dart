
// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/empty.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productDetails.dart';
import 'package:shko/services/local_storage_service.dart';

class ProductsList extends StatefulWidget {
   final String categoryID;
   final categoryName;
   ProductsList(this.categoryID, this.categoryName, {Key? key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<DocumentSnapshot>? productListSnapShot;

  // int favLength;
  List<QueryDocumentSnapshot>  productList=[];
  getProducts() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('products')
        .where('categoryID',isEqualTo: widget.categoryID)
        .get()
        .then((value) {
      productListSnapShot = [];
      productListSnapShot!.addAll(value.docs);
      productList.addAll(value.docs);
      setState(() {});

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
        backgroundColor: Colors.white,

        title: Text(widget.categoryName,style: TextStyle(color: Colors.black87),),
          elevation: 0,
          leading: BackArrowWidget(),
      ),

      body:  (productListSnapShot == null || productListSnapShot!.isEmpty)
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
                List.generate(productListSnapShot!.length, (index) {
                  DocumentSnapshot data= productListSnapShot!.elementAt(index);
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
                              textAlign: TextAlign.center,



                        )
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
