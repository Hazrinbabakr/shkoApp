
// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/all_category.dart';
import 'package:onlineshopping/screen/brandList.dart';
import 'package:onlineshopping/screen/productList.dart';


class Brands extends StatefulWidget {
  const Brands({ key}) : super(key: key);

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  List<DocumentSnapshot> brandsSnapshot;
  getCategry() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('brands')
        .get()
        .then((value) {
      brandsSnapshot = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          brandsSnapshot[i] = element;
        });
        i++;
      });
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


      (brandsSnapshot == null || brandsSnapshot.isEmpty)
          ? SizedBox()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).trans("Brand"),style: TextStyle(fontSize: 22),),
              InkWell(
                  onTap: (){
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => AllCategory(brandsSnapshot)),
                    // );
                  },
                  child:
                  Text( AppLocalizations.of(context).trans("ShowAll"),style: TextStyle(fontSize: 13,color: Theme.of(context).accentColor),)),


            ],
          ),
          SizedBox(height: 15,),
          Container(
            // color: Colors.red,
            // width: 200,
            height: 140,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: brandsSnapshot.length,
                itemBuilder: (context, i) {
                  DocumentSnapshot data= brandsSnapshot.elementAt(i);
                  return (brandsSnapshot[i] != null)

                      ? InkWell(
                    onTap: (){
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => ProductDetails( modelListSnapShot[i].id.toString()),
                      // ));




                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BrandList(
                          data.id.toString(),
                          AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                          data['nameK'].toString():
                          AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                          data['nameA'].toString():
                          data['name'].toString(),


                        ),
                      ));

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child:
                      Column(
                        children: [
                          Container(
                            height: 110,
                            width: 230,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)
                                  //                 <--- border radius here
                                ),
                                border: Border.all(color: Colors.black12,width: 0.6),
                                image: DecorationImage(
                                    //fit: BoxFit.cover,
                                    image: NetworkImage(
                                        brandsSnapshot[i]['img'].toString()))),
                          ),
                          // SizedBox(height: 7,),
                          // Text(
                          //   AppLocalizations.of(context).locale.languageCode.toString()=='ku'? brandsSnapshot[i]['nameK']:
                          //   AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                          //   brandsSnapshot[i]['nameA']:
                          //   brandsSnapshot[i]['name'],
                          //   style: TextStyle(fontWeight: FontWeight.w600,),)
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
