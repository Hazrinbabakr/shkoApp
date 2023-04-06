import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shko/Widgets/BackArrowWidget.dart';
import 'package:shko/Widgets/loading_widget.dart';
import 'package:shko/helper/colors.dart';
import 'package:shko/localization/AppLocal.dart';
import 'package:shko/models/address.dart';
import 'package:shko/providers/address_provider.dart';
import 'package:shko/screen/address/add_address.dart';
import 'package:shko/screen/map/location_picker_page.dart';
import 'package:shko/services/local_storage_service.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
       // leading:  BackArrowWidget(),
        title: Text(AppLocalizations.of(context).trans("myAddress"), style: TextStyle(
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
                      boxShadow: [
                        BoxShadow(
                            color:
                            Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(
                        //     color: Colors.grey[300]
                        // )
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
                                    fontWeight: FontWeight.bold
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
