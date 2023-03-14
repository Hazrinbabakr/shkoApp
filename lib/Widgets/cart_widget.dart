import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineshopping/screen/cart_screen.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({ key}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  FirebaseAuth _auth;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return  FirebaseAuth.instance.currentUser != null ?
    InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartScreen(true),
          ));
        },
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart').snapshots(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  Icon(Icons.shopping_bag_outlined,color: Colors.grey[800],size: 30,),
                  Positioned(
                      top:0,
                      child:snapshot.data?.docs?.length==null? CircularProgressIndicator(): Container(
                          width:16,
                          height:16,
                          decoration: BoxDecoration(
                            color:Colors.red,
                            borderRadius: BorderRadius.all(
                                Radius.circular(15)
                              //                 <--- border radius here
                            ),
                            //   border: Border.all(color: Colors.black12,width: 0.6),
                          ),
                          child: Center(
                            child:
                            Text(snapshot.data?.docs?.length.toString() ?? '0',
                              style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),),
                          ))
                  )
                ],
              );
            }
        )
    ) :SizedBox();
  }
}
