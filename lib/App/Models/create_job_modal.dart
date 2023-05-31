import 'dart:io';

class CreateJobModal {
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupAddress;
  final String pickupAddressDetails;
  final String pickupName;
  final String pickupMobile;
  final String pickupInstructions;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String deliveryAddress;
  final String deliveryAddressDetails;
  final String deliveryName;
  final String deliveryMobile;
  final String deliveryInstructions;
  final String jobType;
  final String deliveryDate;
  final String deliveryTime;
  final String prefferedVehicleChoice;
  final String itemType;
  final String noofItems;
  final int pricepermile;
  final int priceperdeliveryparcel;
  final double pricepermileparcel;
  final String notes;
  final File? image;

  CreateJobModal({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupAddress,
    required this.pickupAddressDetails,
    required this.pickupName,
    required this.pickupMobile,
    required this.pickupInstructions,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryAddress,
    required this.deliveryAddressDetails,
    required this.deliveryName,
    required this.deliveryMobile,
    required this.deliveryInstructions,
    required this.jobType,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.prefferedVehicleChoice,
    required this.itemType,
    required this.noofItems,
    required this.pricepermile,
    required this.priceperdeliveryparcel,
    required this.pricepermileparcel,
    required this.notes,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'pick_up_latitude': pickupLatitude,
      'pick_up_longitude': pickupLongitude,
      'pick_up_address': pickupAddress,
      'pick_up_address_details': pickupAddressDetails,
      'pick_up_name': pickupName,
      'pick_up_mobile': pickupMobile,
      'pick_up_instruction': pickupInstructions,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'delivery_address': deliveryAddress,
      'delivery_address_details': deliveryAddressDetails,
      'delivery_name': deliveryName,
      'delivery_mobile': deliveryMobile,
      'delivery_instruction': deliveryInstructions,
      'job_type': jobType,
      'delivery_date': deliveryDate,
      'delivery_time': deliveryTime,
      'preferred_vehicle_choice': prefferedVehicleChoice,
      'item_type': itemType,
      'no_of_items': noofItems,
      'price_per_mile': pricepermile,
      'price_per_delivery_parcel': priceperdeliveryparcel,
      'price_per_mile_parcel': pricepermileparcel,
      'notes': notes,
      'image': image,
    };
  }
}
