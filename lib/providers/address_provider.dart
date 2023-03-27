import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onlineshopping/models/address.dart';

class AddressProvider {

  CollectionReference _addressCollection = FirebaseFirestore.instance.collection("address");

  Future<List<Address>> getAddresses() async {
    QuerySnapshot res = await _addressCollection
        .where("userId",isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    return res.docs.map((e) => Address.fromJson(e.data(),e.id)).toList();
  }

  Future<Address> addAddress(Address address) async {
    var res = await _addressCollection.add(address.toJson());
    var doc = await res.get();
    return Address.fromJson(doc.data(), doc.id);
  }


}