// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);

import 'dart:convert';

JobsModel jobsModelFromJson(String str) => JobsModel.fromJson(json.decode(str));

class JobsModel {
  JobsModel({
    required this.success,
    required this.jobs,
    required this.pages,
    required this.page,
    required this.limit,
    required this.total,
  });

  final bool success;
  final List<Job> jobs;
  final int pages;
  final int page;
  final int limit;
  final int total;

  factory JobsModel.fromJson(Map<String, dynamic> json) => JobsModel(
        success: json["success"],
        jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
        pages: json["pages"],
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
      );
}

class Job {
  Job({
    required this.id,
    required this.customerId,
    required this.pickUp,
    required this.delivery,
    required this.jobType,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.preferredVehicleChoice,
    required this.packageInfo,
    required this.jobStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.applicants,
    required this.image,
  });

  final String id;
  final String customerId;
  final Delivery pickUp;
  final Delivery delivery;
  final String jobType;
  final DateTime deliveryDate;
  final String deliveryTime;
  final String preferredVehicleChoice;
  final PackageData packageInfo;
  final String jobStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<dynamic> applicants;
  final String image;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["_id"],
        customerId: json["customer_id"],
        pickUp: Delivery.fromJson(json["pick_up"]),
        delivery: Delivery.fromJson(json["delivery"]),
        jobType: json["job_type"],
        deliveryDate: DateTime.parse(json["delivery_date"]),
        deliveryTime: json["delivery_time"],
        preferredVehicleChoice: json["preferred_vehicle_choice"],
        packageInfo: PackageData.fromJson(json["package_info"]),
        jobStatus: json["job_status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        applicants: List<dynamic>.from(json["applicants"].map((x) => x)),
        image: json["attachment"]['url'],
      );
}

class Delivery {
  Delivery({
    required this.loc,
    required this.address,
    required this.addressDetails,
    required this.name,
    required this.mobile,
    required this.instruction,
    required this.id,
  });

  final Loc loc;
  final String address;
  final String addressDetails;
  final String name;
  final String mobile;
  final String instruction;
  final String id;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        loc: Loc.fromJson(json["loc"]),
        address: json["address"]!,
        addressDetails: json["address_details"] ?? "",
        name: json["name"]!,
        mobile: json["mobile"],
        instruction: json["instruction"]!,
        id: json["_id"],
      );
}

class Loc {
  Loc({
    required this.type,
    required this.coordinates,
  });

  final String type;
  final List<double> coordinates;

  factory Loc.fromJson(Map<String, dynamic> json) => Loc(
        type: json["type"]!,
        coordinates: List<double>.from(
            json["coordinates"].map((x) => double.parse(x.toString()))),
      );
}

class PackageData {
  PackageData({
    required this.itemType,
    required this.noOfItems,
    required this.pricePerMile,
    required this.pricePerDeliveryParcel,
    required this.pricePerMileParcel,
    required this.notes,
    required this.id,
  });

  final String itemType;
  final int noOfItems;
  final int pricePerMile;
  final int pricePerDeliveryParcel;
  final double pricePerMileParcel;
  final String notes;
  final String id;

  factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        itemType: json["item_type"],
        noOfItems: json["no_of_items"],
        pricePerMile: json["price_per_mile"],
        pricePerDeliveryParcel: json["price_per_delivery_parcel"],
        pricePerMileParcel:
            double.parse(json["price_per_mile_parcel"].toString()),
        notes: json["notes"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "item_type": itemType,
        "no_of_items": noOfItems,
        "price_per_mile": pricePerMile,
        "price_per_delivery_parcel": pricePerDeliveryParcel,
        "price_per_mile_parcel": pricePerMileParcel,
        "notes": notes,
        "_id": id,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
