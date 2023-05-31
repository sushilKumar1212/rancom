import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_service/places_service.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Customer/PostJob/pickup_page.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Controllers/Customer/JobPost/delivery_controller.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final placeapi = PlacesService();

  @override
  void initState() {
    super.initState();
    placeapi.initialize(apiKey: 'AIzaSyAdOFwxCv9unC7HVDU7B0yIFWZzkNW-oBo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DeliveryController>(
        builder: (BuildContext context, controller, Widget? child) => SizedBox(
          height: Get.height,
          width: Get.width,
          child: AnimatedCrossFade(
            firstChild: searchWidget(),
            secondChild: mapWidget(),
            crossFadeState: controller.showMap
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(
              milliseconds: 370,
            ),
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Consumer<DeliveryController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: getVerticalSize(20)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.grey,
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: controller.searchAddressController,
                    decoration: const InputDecoration(
                      hintText: "Search Area/Locality",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.getPlaces();
                      } else {
                        controller.clearPlaces();
                      }
                    },
                  ),
                ),
                SizedBox(height: getVerticalSize(10)),
                if (controller.places.isNotEmpty)
                  controller.isloading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            padding: EdgeInsets.zero,
                            itemCount: controller.places.length,
                            itemBuilder: (context, index) {
                              return tapper(
                                onPressed: () async {
                                  controller.changeMap(true);
                                  final address =
                                      await placeapi.getPlaceDetails(controller
                                          .places[index]['id']
                                          .toString());
                                  final location =
                                      await placemarkFromCoordinates(
                                    address.lat ?? 0.0,
                                    address.lng ?? 0.0,
                                  );
                                  controller.addressController.text =
                                      addressfromplacemark(location[0]);
                                  controller.addressDetailsController.text =
                                      '${location[0].street}, ${location[0].subLocality}';
                                  controller.changeDeliveryLocation(
                                    lat: address.lat ?? 0.0,
                                    long: address.lng ?? 0.0,
                                  );
                                  completer.future.then(
                                    (value) => value.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(
                                            address.lat ?? 0.0,
                                            address.lng ?? 0.0,
                                          ),
                                          zoom: 15,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: getVerticalSize(62),
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Octicons.location,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(
                                        width: getHorizontalSize(10),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            myText(
                                              controller.places[index]['title']
                                                  .toString(),
                                              maxLines: 1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: getVerticalSize(5),
                                            ),
                                            myText(
                                              controller.places[index]
                                                      ['subtitle']
                                                  .toString(),
                                              maxLines: 2,
                                              fontSize: 14,
                                              color: AppColors.darkGrey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                else
                  tapper(
                    onPressed: () async {
                      await controller.getCurrentLocation().then((value) {
                        controller.changeMap(true);
                        completer.future.then(
                          (value) => value.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  controller.lat,
                                  controller.long,
                                ),
                                zoom: 15,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Octicons.location,
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        myText(
                          "Use Current Location",
                          fontSize: 16,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  final Completer<GoogleMapController> completer =
      Completer<GoogleMapController>();

  Widget mapWidget() {
    return Consumer<DeliveryController>(builder: (context, controller, child) {
      return SizedBox(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getVerticalSize(210),
                width: Get.width,
                child: Listener(
                  onPointerDown: (event) {
                    controller.ispickupChanged = true;
                    controller.notifyListeners();
                  },
                  child: GoogleMap(
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(controller.lat, controller.long),
                    ),
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId("1"),
                        position: LatLng(controller.lat, controller.long),
                      ),
                    },
                    onCameraMove: (position) {
                      if (controller.ispickupChanged) {
                        controller.changeDeliveryLocation(
                          lat: position.target.latitude,
                          long: position.target.longitude,
                        );
                      }
                    },
                    onCameraIdle: () async {
                      if (controller.ispickupChanged) {
                        final address = await placemarkFromCoordinates(
                          controller.lat,
                          controller.long,
                        );
                        controller.addressController.text =
                            addressfromplacemark(
                          address.first,
                        );
                      }
                    },
                    onMapCreated: (controller) {
                      completer.complete(controller);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    normalTextBox(
                      controller: controller.addressController,
                      readOnly: true,
                      endWidget: tapper(
                        onPressed: () {
                          controller.changeMap(false);
                        },
                        child: myText(
                          "Change",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      controller: controller.addressDetailsController,
                      hintText: "Address Details",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      controller: controller.nameController,
                      hintText: "Name",
                      formatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      controller: controller.phoneNumberController,
                      hintText: "Mobile",
                      keyboardType: TextInputType.number,
                      formatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      controller: controller.instructionController,
                      hintText: "Instructions",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    tapper(
                      onPressed: () {
                        controller.nextPage(context);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: myText(
                            "Next",
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
