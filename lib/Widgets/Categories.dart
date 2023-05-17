
// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/all_category.dart';
import 'package:shko/screen/productList.dart';


class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({ key}) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List<DocumentSnapshot>? categorySnapshot;
  getCategry() {
    FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) {
      categorySnapshot = [];
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
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( AppLocalizations.of(context).trans("categories"),style: TextStyle(fontSize: 22,),),
              InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllCategory(categorySnapshot!)),
                    );
                  },
                  child:
                  Text( AppLocalizations.of(context).trans("ShowAll"),style: TextStyle(fontSize: 13,color: Theme.of(context).accentColor),)),

            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
               //color: Colors.red,
              // width: 200,
              height: 130,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: categorySnapshot!.length,
                  itemBuilder: (context, i) {
                    DocumentSnapshot data= categorySnapshot!.elementAt(i);
                    return (categorySnapshot![i] != null)

                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                      onTap: (){
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => ProductDetails( modelListSnapShot[i].id.toString()),
                          // ));




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
                      child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child:
                          Column(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  //color: Colors.white,
                                  //   borderRadius: BorderRadius.all(
                                  //       Radius.circular(15)
                                  //     //                 <--- border radius here
                                  //   ),
                                   // border: Border.all(color: Colors.black12,width: 0.6),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(

                                            categorySnapshot![i]['img'].toString()))),
                              ),
                              SizedBox(height: 7,),
                              Text(
                                AppLocalizations.of(context).locale.languageCode.toString()=='ku'? categorySnapshot![i]['nameK']:
                                AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                categorySnapshot![i]['nameA']:
                                categorySnapshot![i]['name'],
                                style: TextStyle(fontWeight: FontWeight.w600,),)
                            ],
                          ),



                      ),),
                        )
                        : SizedBox();
                  }),
            ),
          ),
        ],
      );



  }
}
