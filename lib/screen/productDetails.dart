import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/cart_widget.dart';
import 'package:shko/Widgets/empty.dart';
import 'package:shko/Widgets/photo_gellary.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productDetailPDF.dart';
import 'package:shko/services/local_storage_service.dart';

import 'auth/normal_user_login/login_main_page.dart';

class ProductDetails extends StatefulWidget {
  final String productID;
  const ProductDetails(this.productID, {Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DocumentSnapshot? productDetailSnapShot;
  Map<String,dynamic>? productSnapshot;
  var formatter = NumberFormat('#,###,000');


  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<String> imgList=[];
  int _current = 0;

  int inPrice= 0;
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future getProducts() async{
    productDetailSnapShot = await FirebaseFirestore.instance
        .collection('products').doc(widget.productID)
        .get();
    setState(() {
      productSnapshot=productDetailSnapShot!.data() as Map<String,dynamic>;
      // inPrice= int.parse(productSnapshot.data()['retail price']);
      // //print(inPrice.toString());
      ////print('${productDetailSnapShot.data()['images'].toString()} imgggg');
      productSnapshot!['images'].forEach((element){
        imgList.add(element);
      });
      // imgList.add(productDetailSnapShot.data()['images'].toString());
      // //print('${productDetailSnapShot.data()['images'].length.toString()} imgggg');

    });
  }
  @override
  void initState() {
    getProducts();
    if(  FirebaseAuth.instance.currentUser != null ){
      setState(() {
        getFavList();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,

          elevation: 0,
          // title: Text('Product details',style: TextStyle(color: mainColor),),
          leading: BackArrowWidget(),
          actions: [
            Row(
              children: [
                isfav? InkWell(
                  onTap: (){
                    setState(() {
                      User user = _auth.currentUser!;
                      userCollection
                          .doc(user.uid)
                          .collection('favorite')
                          .doc(widget.productID).delete();
                      // //print('added to fav');
                      isfav= !isfav;
                      //Scaffold.of(context).showSnackBar(_snackBarRemoveFromFav);

                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ):
                InkWell(
                  onTap: (){


                    setState(() {
                      if(   FirebaseAuth.instance.currentUser != null){
                        User user = _auth.currentUser!;
                        userCollection
                            .doc(user.uid)
                            .collection('favorite')
                            .doc(widget.productID)
                            .set({
                          "productID":widget.productID
                        });
                        isfav= !isfav;

                      }else{
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainLoginPage(),
                        ));
                      }

                    });


                  },
                  child: Icon(
                    Icons.favorite_border,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 20),
                  child: CartWidget(),
                ),
              ],
            ),

          ],
        ),
        body:

        Builder(
            builder: (BuildContext context){
              return  productSnapshot==null?
              EmptyWidget():
              //Text(snapshot.data()['name']),
              Stack(
                fit: StackFit.expand,
                children: <Widget>[

                  Container(

                    margin: EdgeInsets.only(bottom: 125),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[

                        SliverAppBar(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.vertical(
                          //     bottom: Radius.circular(35),
                          //   ),
                          // ),
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.9),
                          //size
                          expandedHeight: 300,
                          floating: false,
                          pinned: true,
                          snap: false,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          flexibleSpace:
                          FlexibleSpaceBar(
                            //collapseMode: CollapseMode.pin,
                            background: GestureDetector(
                              onTap: () {

                              },
                              child: Hero(
                                tag: 'testt',
                                child: imgList==null
                                    ? Container(

                                  child:
                                  Center(child:CircularProgressIndicator()),
                                )
                                    :  Column(
                                      children: [
                                        Container(
                                  //color: Colors.red,
                                          child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:Stack(
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    //height: 300,
                                                    viewportFraction: 0.74,
                                                    autoPlay: false,
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        _current = index;
                                                      });
                                                    }),

                                                items: imgList.map((i) {
                                                  return Builder(

                                                    builder: (BuildContext context) {

                                                      return
                                                        // Text('ssss ${i['test1'].toString()}');
                                                        GestureDetector(
                                                          onTap: (){
                                                            int ind = 0;
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        PhotosGalleryPage(
                                                                          initialPage: 0,
                                                                          galleryItems: [
                                                                            GalleryItem(
                                                                                id: widget.productID
                                                                                    +
                                                                                    "_" +
                                                                                    (ind++)
                                                                                        .toString(),
                                                                                image: i)
                                                                          ],
                                                                        )
                                                                )
                                                            );
                                                          },
                                                          child: Container(
                                                            //  height:450,
                                                            // width: 700,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage(i.toString())),),

                                                            //child: Text(i.toString()),
                                                          ),
                                                        );
                                                    },
                                                  );
                                                }).toList(),
                                              ),

                                            ],
                                          )


                                ),
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            for (int i = 0; i < imgList.length; i++)
                                              Center(
                                                child: Container(
                                                  height: 8,
                                                  width: 8,
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: _current == i ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //       color: Colors.grey,
                                                      //       spreadRadius: 1,
                                                      //       blurRadius: 3,
                                                      //       offset: Offset(2, 2))
                                                      // ]
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ),

                        ),

                        SliverToBoxAdapter(
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.pinkAccent,
                              color: Colors.white,
                              // borderRadius: BorderRadius.only(
                              //   topLeft: Radius.circular(20),
                              //   topRight: Radius.circular(20)
                              // )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child:  Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          // color: Colors.red,
                                          child: Text(

                                            AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                            productSnapshot!['nameK'] ?? '':
                                            AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                            productSnapshot!['nameA'] ?? '':
                                            productSnapshot!['name'] ?? '',

                                            // overflow: TextOverflow.fade,
                                            maxLines: 3,
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .headline3!
                                                .merge(TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black
                                            )),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child:
                                        productSnapshot!['quantity']==0 ||productSnapshot!['quantity']<0 ||productSnapshot!['quantity']< quantity?
                                        // productSnapshot!['quantity']==0?
                                        Text('Out of Stock',
                                          style: TextStyle(
                                              fontSize: 12,fontWeight: FontWeight.bold,color: Colors.red),
                                        ):
                                        Text(AppLocalizations.of(context).trans("Availability"),
                                          style: TextStyle(
                                              fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15,),
                                    child: Container(
                                        height: 40,
                                        width: 140,
                                        //color: Colors.red,
                                        child:  Row(
                                          children: [

                                            Text(  '${ formatter.format(productSnapshot!['sellPrice']).toString()}',
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            Text(' IQD',style:
                                            TextStyle(fontSize: 14),),
                                          ],
                                        )
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                    productSnapshot!['descK'] ?? '':
                                    AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                    productSnapshot!['descA'] ?? '':
                                    productSnapshot!['desc'] ?? '',


                                    style: TextStyle(fontSize: 16,height: 1.3),),


                                  // Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                                  //     children: <Widget>[
                                  //       DefaultTabController(
                                  //         length: 2, // length of tabs
                                  //         initialIndex: 0,
                                  //         child: Container(
                                  //           // color: Colors.red,
                                  //           child: TabBar(
                                  //             indicatorColor: Theme.of(context).accentColor,
                                  //             indicatorPadding: EdgeInsets.all(0),
                                  //             labelPadding: EdgeInsets.symmetric(horizontal: 50),
                                  //             // indicator: UnderlineTabIndicator(
                                  //             //     borderSide: BorderSide(width: 1.0),
                                  //             //     insets: EdgeInsets.symmetric(horizontal:10.0)
                                  //             // ),
                                  //             //indicatorSize: TabBarIndicatorSize.,//TabBarIndicatorSize(3),
                                  //             onTap: (index){
                                  //               setState(() {
                                  //                 selectedIndex = index;
                                  //               });
                                  //             },
                                  //             isScrollable: true,
                                  //             tabs: [
                                  //               Tab(text:  "Specification"),
                                  //               Tab(text:  "Description"),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //           decoration: BoxDecoration(
                                  //               border: Border(
                                  //                   top: BorderSide(
                                  //                       color: Colors.grey,
                                  //                       width: 0.5))),
                                  //           child: Padding(
                                  //               padding:
                                  //               const EdgeInsets.all(15.0),
                                  //               child: getCurrentPage()
                                  //           ))
                                  //     ])



                                ],



                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //
                  //   color: Colors.red,
                  //   child: Text('ss'),
                  // ),

                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 1.01,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 1,
                                blurRadius: 10)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //countnumber
                          Container(
                           // width:180,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(quantity>1){
                                        quantity= quantity-1;
                                      }
                                    });
                                  },

                                  child: Icon(
                                    Icons.remove,
                                    size: 25,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Container(

                                    padding: EdgeInsets.symmetric(
                                        vertical: 10),
                                    height: 40,
                                    width: 40,
                                    // color: Colors.red,
                                    child:  Center(child:
                                    Text(quantity.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                                    )
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      quantity= quantity+1;

                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 25,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width:65,),
                          // addtocart
                          productSnapshot!['quantity']==0 ||productSnapshot!['quantity']<0  ||productSnapshot!['quantity']< quantity?
              Container(
              width: 170,
              padding: EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
              color:Colors.grey,
              borderRadius:
              BorderRadius.circular(12)),
              child: InkWell(
              onTap: () {
print('out of stock');
              },
              child: Text(
              AppLocalizations.of(context).trans("Addtocart"),
              textAlign:
              TextAlign.center,
              style: TextStyle(
              color:
              Theme.of(context)
                  .primaryColor,
              fontSize: 17,
              fontWeight:
              FontWeight.w600),
              ),
              ),
              )
                              :
                          //Addtocart
                          Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius:
                                BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {


                                setState(() {
                                  if(   FirebaseAuth.instance.currentUser != null){
                                    User user = _auth.currentUser!;
                                    userCollection
                                        .doc(user.uid)
                                        .collection('cart')
                                        .doc(widget.productID)
                                        .set({
                                      "availableQuantity": productSnapshot!['quantity'],
                                      "productID": widget.productID,
                                      "quantity": quantity,
                                      "price": productSnapshot!['sellPrice'],
                                      "name": productSnapshot!['name'],
                                      "nameA": productSnapshot!['nameA'],
                                      "nameK": productSnapshot!['nameK'],
                                      "supPrice":
                                      (productSnapshot!['sellPrice']) * quantity,

                                      "img": productSnapshot!['images'][0],
                                    });
                                    //print('added');
                                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);

                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MainLoginPage(),
                                    ));
                                  }

                                });







                              },
                              child: Text(
                                AppLocalizations.of(context).trans("Addtocart"),
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                    color:
                                    Theme.of(context)
                                        .primaryColor,
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.w600),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                ],
              );
            }
        )


    );
  }






  int quantity = 1;

  final _snackBar = SnackBar(
    content:
    Text('Added Successfully',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 2),
  );

  final _snackBarAddToFav = SnackBar(
    content:
    Text('Added To Favorite',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 1),
  );
  final _snackBarRemoveFromFav = SnackBar(
    content:
    Text('Removed From Favorite',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 1),
  );
  bool isfav=false;
  List<DocumentSnapshot>? getFav;
  List <String> favList=[];


  getFavList() {

    int i = 0;
    FirebaseFirestore.instance.collection('users').doc(user!.uid)
        .collection('favorite').get().then((value) {
      getFav = [];
      getFav!.addAll(value.docs);
      favList.addAll(getFav!.map((e) => e.id));
      if(favList.contains(widget.productID)){
        isfav=true;
      }else{
        isfav=false;
      }
      setState(() {});
    });

  }




}
