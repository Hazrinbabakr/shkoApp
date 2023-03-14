


import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onlineshopping/Widgets/BackArrowWidget.dart';
import 'package:onlineshopping/Widgets/cart_widget.dart';
import 'package:onlineshopping/Widgets/empty.dart';
import 'package:onlineshopping/Widgets/photo_gellary.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/screen/productDetailPDF.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

class ProductDetails extends StatefulWidget {
  final String productID;
  const ProductDetails(this.productID, {Key key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DocumentSnapshot productDetailSnapShot;
  DocumentSnapshot productSnapshot;


  FirebaseAuth _auth;
  User user;
  List<String> imgList=[];
  int _current = 0;

  int inPrice= 0;
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future getProducts() async{
    productDetailSnapShot = await FirebaseFirestore.instance
        .collection('products').doc(widget.productID)
        .get();
    setState(() {
      productSnapshot=productDetailSnapShot;
      // inPrice= int.parse(productSnapshot.data()['retail price']);
      // //print(inPrice.toString());
      ////print('${productDetailSnapShot.data()['images'].toString()} imgggg');
      productDetailSnapShot.data()['images'].forEach((element){
        imgList.add(element);
      });
      // imgList.add(productDetailSnapShot.data()['images'].toString());
      // //print('${productDetailSnapShot.data()['images'].length.toString()} imgggg');

    });
  }
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    user= _auth.currentUser;
    getProducts();
    getFavList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // title: Text('Product details',style: TextStyle(color: mainColor),),
          leading: BackArrowWidget(),
          actions: [
            Row(
              children: [
                isfav? InkWell(
                  onTap: (){
                    setState(() {
                      User user = _auth.currentUser;
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
                    color: Theme.of(context).accentColor,
                  ),
                ):
                InkWell(
                  onTap: (){
                    setState(() {
                      User user = _auth.currentUser;
                      userCollection
                          .doc(user.uid)
                          .collection('favorite')
                          .doc(widget.productID)
                          .set({
                        "productID":widget.productID
                      });
                      isfav= !isfav;
                      // //print('added to fav');
                     // Scaffold.of(context).showSnackBar(_snackBarAddToFav);
                    });
                  },
                  child: Icon(
                    Icons.favorite_border,
                    size: 30,
                    color: Theme.of(context).accentColor,
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
                          expandedHeight: 270,
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
                                        SizedBox(height: 20,),
                                        Container(
                                  //color: Colors.red,
                                          child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:Stack(
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    //height: 300,
                                                    viewportFraction: 1,
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
                                                            // height: heightt-450,
                                                            //width: 700,
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
                                                      color: _current == i ? Theme.of(context).accentColor : Theme.of(context).accentColor.withOpacity(0.2),
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
                                  horizontal: 5, vertical: 15),
                              child: Wrap(
                                runSpacing: 10,
                                children: [
                                  Column(

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
                                                productSnapshot.data()['nameK'] ?? '':
                                                AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                                productSnapshot.data()['nameA'] ?? '':
                                                productSnapshot.data()['name'] ?? '',

                                                // overflow: TextOverflow.fade,
                                                maxLines: 3,
                                                style: Theme.of(
                                                    context)
                                                    .textTheme
                                                    .headline3
                                                    .merge(TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.black
                                                )),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: productSnapshot.data()['quantity']==0?
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
                                                Text('${productSnapshot['price'].toString()}',
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
                                        productSnapshot.data()['descK'] ?? '':
                                        AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                        productSnapshot.data()['descA'] ?? '':
                                        productSnapshot.data()['desc'] ?? '',


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


                                  SizedBox(
                                    height: 190,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 100,
                      // width: double.infinity,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                spreadRadius: 1,
                                blurRadius: 10)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20),
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
                            productSnapshot.data()['quantity']==0?
                            Center(
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: AlignmentDirectional.centerEnd,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width -
                                        110,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: InkWell(
                                        onTap: () {
                                          //print('out of stock');
                                          // showErrorToast(context,
                                          //     S.of(context).out_of_stock);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context).trans("Addtocart"),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Icon(
                                                  Icons
                                                      .shopping_cart_outlined,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    // child: Helper.getPrice(
                                    //   _con.total,
                                    //   context,
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .headline4
                                    //       .merge(TextStyle(
                                    //           color: Theme.of(context)
                                    //               .primaryColor)),
                                    // ),
                                  ),
                                ],
                              ),
                            )
                                :
                            //Addtocart
                            Container(
                              width: 170,
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {
                                  //Addtocart
                                  User user = _auth.currentUser;
                                  userCollection
                                      .doc(user.uid)
                                      .collection('cart')
                                      .doc(widget.productID)
                                      .set({
                                    "productID": widget.productID,
                                    "quantity": quantity,
                                    "price": productSnapshot['price'],
                                    "name": productSnapshot.data()['name'],
                                    "nameA": productSnapshot.data()['nameA'],
                                    "nameK": productSnapshot.data()['nameK'],
                                    "supPrice":
                                    (productSnapshot['price']) * quantity,

                                    "img": productSnapshot.data()['images'][0],
                                  });
                                  //print('added');
                                  Scaffold.of(context).showSnackBar(_snackBar);

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
                  ),

                ],
              );
            }
        )


    );
  }
  // int selectedIndex = 0;
  // getCurrentPage(){
  //   if(selectedIndex == 1){
  //     return Text(productSnapshot.data()['desc'],style: TextStyle(fontSize: 16,height: 1.3),);
  //
  //   }else if (selectedIndex == 0){
  //     return
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(height: 15,),
  //
  //
  //           SizedBox(height: 15,),
  //           Row(
  //             //mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Expanded(
  //                 child: Text('oemCode',
  //                   maxLines: 3,
  //                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Text(productSnapshot.data()['oemCode'].toString(),
  //                   maxLines: 5,
  //                   style: TextStyle(fontSize: 15),
  //                 ),
  //               )
  //             ],),
  //           SizedBox(height: 15,),
  //
  //
  //
  //
  //
  //         ],);
  //
  //   }
  //
  // }





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
  List<DocumentSnapshot> getFav;
  List <String> favList=[];


  getFavList() {

    int i = 0;
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('favorite').get().then((value) {
      getFav = new List<DocumentSnapshot>(value.docs.length);
      value.docs.forEach((element) async {
        setState(() {
          getFav[i] = element;
          favList.add(getFav[i].id);
          if(favList.contains(widget.productID)){
            isfav=true;
          }else{
            isfav=false;
          }

          //print('$isfav    issfavvvvv');
        });
        i++;
      });
    });

  }




}
