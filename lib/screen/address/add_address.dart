import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:onlineshopping/Widgets/CustomAppButton.dart';
import 'package:onlineshopping/Widgets/text-field.dart';
import 'package:onlineshopping/helper/colors.dart';
import 'package:onlineshopping/localization/AppLocal.dart';
import 'package:onlineshopping/models/address.dart';
import 'package:onlineshopping/providers/address_provider.dart';
import 'package:onlineshopping/screen/address/address_text_field.dart';
import 'package:onlineshopping/screen/map/location_picker_page.dart';
import 'package:onlineshopping/screen/map/map_page.dart';

class AddAddress extends StatefulWidget {
  final double lat,long;
  const AddAddress({Key key, this.lat, this.long}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  double lat;
  double long;

  bool _loading = false;

  final AddressProvider _addressProvider = AddressProvider();


  @override
  void initState() {
    lat = widget.lat;
    long = widget.long;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).trans("add_address")),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).dividerColor
                          )
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: MapWidget(
                                key: ValueKey<String>("$lat,$long"),
                                defaultPosition: LatLng(lat,long),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: CustomAppButton(
                                onTap: () async {
                                  var res = await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context){
                                      return LocationPickerPage();
                                    }
                                  ));

                                  if(res!= null){
                                    LocationData location = res as LocationData;
                                    lat = location.latitude;
                                    long = location.longitude;
                                    setState(() {

                                    });
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                  vertical: 12
                                ),
                                elevation: 0,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).trans("refine_location"),
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6,)
                          ],
                        ),
                      ),
                      const SizedBox(height: 24,),
                      AddressTextFieldItem(
                        title: AppLocalizations.of(context).trans("title"),
                        controller: titleController,
                      ),
                      const SizedBox(height: 12,),
                      AddressTextFieldItem(
                        title: AppLocalizations.of(context).trans("description"),
                        controller: descController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20
              ),
              child: SizedBox(
                height: 60,
                child: CustomAppButton(
                  onTap: () async {
                    try{
                      setState(() {
                        _loading = true;
                      });
                      var res  = await _addressProvider.addAddress(Address(
                          title: titleController.text,
                          description: descController.text,
                          latitude: lat,
                          longitude: long
                      ));
                      Navigator.of(context).pop(res);
                    } catch(error) {
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                  color: AppColors.accent,
                  borderRadius: 15,
                  child: Center(
                    child: _loading ?
                    CircularProgressIndicator():
                    Text(
                      AppLocalizations.of(context).trans("save"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}
