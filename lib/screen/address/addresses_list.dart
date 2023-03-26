import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:onlineshopping/Widgets/loading_widget.dart';
import 'package:onlineshopping/helper/colors.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/models/address.dart';
import 'package:onlineshopping/providers/address_provider.dart';
import 'package:onlineshopping/screen/address/add_address.dart';
import 'package:onlineshopping/screen/map/location_picker_page.dart';
import 'package:onlineshopping/services/local_storage_service.dart';

class AddressesList extends StatefulWidget {
  const AddressesList({Key key}) : super(key: key);

  @override
  State<AddressesList> createState() => _AddressesListState();
}

class _AddressesListState extends State<AddressesList> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).trans("addresses"), style: TextStyle(
          fontSize: 19,
        ),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res =
          // LocationData.fromMap({
          //   "latitude":36.201991,
          //   "longitude":43.987194
          // });
          await Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return LocationPickerPage(
              yLatitude: 36.201991,
              xLongitude: 43.987194,
            );
          }));
          if(res != null){
            LocationData location = res as LocationData;
            await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return AddAddress(
                lat: location.latitude,
                long: location.longitude,
              );
            }));
            addresses = null;
            setState(() {

            });
            getAddresses();
          }
        },
        backgroundColor: AppColors.accent,
        child: Icon(Icons.add , color: Colors.white,size: 20,),
      ),

    );
  }
}
