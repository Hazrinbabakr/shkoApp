import 'package:flutter/material.dart';
import 'package:onlineshopping/Widgets/loading_widget.dart';
import 'package:onlineshopping/models/address.dart';
import 'package:onlineshopping/providers/address_provider.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

class AddressesBottomSheet extends StatefulWidget {
  const AddressesBottomSheet({Key key}) : super(key: key);


  static show(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return AddressesBottomSheet();
        }
    );
  }
  @override
  State<AddressesBottomSheet> createState() => _AddressesBottomSheetState();
}

class _AddressesBottomSheetState extends State<AddressesBottomSheet> {


  AddressProvider databaseManager = AddressProvider();

  List<Address> addresses;
  @override
  void initState() {
    getAddresses();
    super.initState();
  }

  getAddresses(){
    databaseManager.getAddresses().then((value) {
      if(value != null){
        addresses = value;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {

          });
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            )
          ],
        ),
        Expanded(
          child: Builder(
            builder: (context){
              if(addresses != null){
                return ListView.separated(
                  itemCount: addresses.length,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12
                  ),
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        LocalStorageService.instance.selectedAddress = addresses[index];
                        Navigator.of(context).pop();
                        setState(() {

                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: Colors.grey
                            )
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 24
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addresses[index].title,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Text(
                                    addresses[index].description,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(LocalStorageService.instance.selectedAddress == addresses[index])
                              Icon(Icons.check , size: 25,color: Colors.green,)
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12,);
                  },
                );
              }
              return LoadingWidget();
            },
          ),
        ),
      ],
    );
  }
}
