// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/Widgets/BackArrowWidget.dart';
import 'package:onlineshopping/Widgets/empty.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/productDetails.dart';
import 'package:onlineshopping/services/local_storage_service.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key key}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final userCollection = FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot> allProductListSnapShot;
  List<DocumentSnapshot> favListSnapShot;
  User user;
  FirebaseAuth _auth;
  int favLength;
  List<String> favList=[];
  getFavProduct() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection('favorite')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        favListSnapShot = new List<DocumentSnapshot>(value.docs.length);
        setState(() {
          favListSnapShot[i] =  element;
          favLength=favListSnapShot.length;
          favList.add(favListSnapShot[i].id);
        });
        i++;
      });
    }).whenComplete((){
      if(favLength !=null){
        getAllProduct();
      }
    });
  }
  getAllProduct() {
    allProductListSnapShot = new List<DocumentSnapshot>(favLength);
    // allProductList = new List<Map>(productListSnapShot.length);
    for(int i=0; i<favLength;i++) {
      FirebaseFirestore.instance
          .collection('products').where("productID", isEqualTo: favList[i])
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          setState(() {
            allProductListSnapShot[i] =  element;
          });
          i++;
        });
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth= FirebaseAuth.instance;
    user=_auth.currentUser;
    getFavProduct();
// Future.delayed(Duration(seconds: 2),(){
//   getAllProduct();
// });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackArrowWidget(),
         // automaticallyImplyLeading: false,
            title: Text(AppLocalizations.of(context).trans("Favorite"),),
            elevation: 0,
        ),

        body:
        (allProductListSnapShot == null)
            ? EmptyWidget()
            : GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,

          crossAxisSpacing: 12,
          //mainAxisSpacing: 15,
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
              List.generate(allProductListSnapShot.length, (i) {
                //DocumentSnapshot data= allProductListSnapShot.elementAt(i);
                return (allProductListSnapShot[i] != null)
                    ? InkWell(
                  onTap: (){
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => ProductDetails( allProductListSnapShot[i].id.toString()),
                    // ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        Container(
                            //height: 900,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)
                                  //                 <--- border radius here
                                ),
                                border: Border.all(color: Colors.black12,width: 0.6),
                            ),
                            child: Column(
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 90,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)
                                        //                 <--- border radius here
                                      ),
                                      //border: Border.all(color: Colors.black12,width: 0.6),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              allProductListSnapShot[i]['images'][0].toString()))),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  //color: Colors.red,
                                    width: 170,
                                    child: Text(
                                      AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                      allProductListSnapShot[i]['nameK'].toString().toUpperCase():
                                      AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                      allProductListSnapShot[i]['nameA'].toString().toUpperCase():
                                      allProductListSnapShot[i]['name'].toString().toUpperCase(),
textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,), overflow: TextOverflow.visible,maxLines: 3,)),
                               // SizedBox(height: 5,),
                                //LocalStorageService.instance.user.role == 1?
                                Center(
                                  child: Text('${allProductListSnapShot[i]['price'].toString()}\$',
                                    style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
                                ),

                                //SizedBox(width: 30,),

                              ],
                            )),
                      Positioned(
                          right: 10,
                          top:10,
                          child: InkWell(
                              onTap: (){
                                setState(() {
                                  User user = _auth.currentUser;
                                  userCollection
                                      .doc(user.uid)
                                      .collection('favorite')
                                      .doc(allProductListSnapShot[i].id).delete();
                                  getFavProduct();

                                  // getAllProduct();
                                  print('${allProductListSnapShot[i]['name']}  deleted');
                                });
                              },
                              child: Icon(Icons.favorite,size: 30,color: Colors.red[900],)))
                      ],
                    ),
                  ),)
                    : SizedBox();
              }),
            )
    );
  }
}



