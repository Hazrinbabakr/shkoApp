
// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productList.dart';


class SearchCategory extends StatefulWidget {
  const SearchCategory({ key}) : super(key: key);

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<SearchCategory> {
  List<DocumentSnapshot>? categorySnapshot;
  getCategry() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) {
      categorySnapshot = [];
      categorySnapshot!.addAll(value.docs);
      setState(() {});
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategry();
  }
  @override
  Widget build(BuildContext context) {
    return


      (categorySnapshot == null || categorySnapshot!.isEmpty)
          ? SizedBox()
          :  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
         childAspectRatio: 0.75,
        //childAspectRatio: 1, // (itemWidth/itemHeight),
        // padding: EdgeInsets.symmetric(
        //     horizontal: 0, vertical: 10),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: MediaQuery.of(context).orientation ==
              Orientation.portrait
              ? 3
              : 4,
        children:
        List.generate(categorySnapshot!.length, (i) {
            DocumentSnapshot data= categorySnapshot!.elementAt(i);
            return  InkWell(
              onTap: (){



                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductsList(
                    data.id.toString(),
                    AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                    data['nameK'].toString():
                    AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                    data['nameA'].toString():
                    data['name'].toString(),


                  ),
                ));

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  //border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(18),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 10.0,
                  //   ),
                  // ],
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      //  color: Colors.red,
                      height:85,
                      width: 80,
                      child: Image.network(
                          categorySnapshot![i]['img'].toString()??""
                      ),
                    ),
                    SizedBox(height: 25,),
                    Text(
                      AppLocalizations.of(context).locale.languageCode.toString()=='ku'? categorySnapshot![i]['nameK']:
                      AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                      categorySnapshot![i]['nameA']:
                      categorySnapshot![i]['name'],
                      maxLines: 1,
                      style: TextStyle(color: Colors.grey[600],fontSize: 14),),
                    SizedBox(height:5,),

                  ],
                ),
              ),);
        }),
      ),
          );



  }
}
