import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shko/Widgets/brands.dart';
import 'package:shko/Widgets/searchCategory.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/screen/productDetails.dart';



class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? searchInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  // trailing: IconButton(
                  //   icon: Icon(Icons.close),
                  //   color: Theme.of(context).hintColor,
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  title: Center(
                    child: Text(
                      AppLocalizations.of(context).trans('categories'),

                      style: TextStyle(color: Colors.grey,fontSize: 23),
                    ),
                  ),
//              subtitle: Text(
//                S.of(context).ordered_by_nearby_first,
//                style: Theme.of(context).textTheme.caption,
//              ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                child: Container(
height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(18),
                    // boxShadow: <BoxShadow>[
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     offset: Offset(1.0, 6.0),
                    //     blurRadius: 10.0,
                    //   ),
                    // ],
                  ),
                  child: Center(
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      // onSubmitted: (val){
                      //
                      //   setState(() {
                      //     searchInput = val[0].toUpperCase() + val.substring(1);
                      //     print(searchInput);
                      //   });
                      // },
                      onChanged: (val) {
                        setState(() {
                          searchInput = val[0].toUpperCase() + val.substring(1);
                         // print(searchInput);
                        });
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: AppLocalizations.of(context).trans('Searchforyourproduct'),
                        hintStyle: TextStyle(fontSize: 14,color: Colors.grey,),
                        prefixIcon:
                        Image.asset('images/category/search.png',color: Colors.grey,),
//                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1)),borderRadius: BorderRadius.circular(40)),
                        border: InputBorder.none,
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(
                        //         color: Colors.grey),
                        //     borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ),
              ),


              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      (searchInput != "" && searchInput != null)
                          ? StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('products').snapshots(),
                          builder: (_, snapshot) {
                            return Container(
                              //color: Colors.red,
                              height: 600,
                              child: ListView.builder(
                                itemCount: snapshot.data?.docs?.length ?? 0,
                                itemBuilder: (_, index) {
                                  String searchWord;
                                  searchWord =
                                  AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                  snapshot.data!.docs[index].data()['nameK']:
                                  AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                  // ignore: unnecessary_statements
                                  snapshot.data!.docs[index].data()['makeA']:
                                  // ignore: unnecessary_statements
                                  snapshot.data!.docs[index].data()['name'];
                                  if (snapshot.hasData &&
                                      searchWord.contains(searchInput??"")) {
                                    DocumentSnapshot shops =
                                    snapshot.data!.docs[index];
                                    return InkWell(
                                      onTap: () {

                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ProductDetails(snapshot.data!.docs[index].id),
                                        ));
                                      },
                                      child: Card(
                                        child: Row(
                                         // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)
                                                    //                 <--- border radius here
                                                  ),
                                                 // border: Border.all(color: Colors.black12,width: 0.6),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          shops['images'][0].toString()))),
                                            ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: Text(
                                                  AppLocalizations.of(context).locale.languageCode.toString()=='ku'?
                                                  shops['nameK'].toString():
                                                  AppLocalizations.of(context).locale.languageCode.toString()=='ar'?
                                                  // ignore: unnecessary_statements
                                                  shops['nameA'].toString():
                                                  // ignore: unnecessary_statements
                                                  shops['name'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                            ),
                                            SizedBox(width: 20,),
                                            Text(

                                             '${ shops['sellPrice'].toString()} IQD',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  ),
                                            ),
                                            SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            );
                          })
                          :
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            SearchCategory(),
                            SizedBox(height: 65,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 15),
                              child: Brands(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
