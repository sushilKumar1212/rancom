// To parse this JSON data, do
//
//     final driverJobsModel = driverJobsModelFromJson(jsonString);

import 'dart:convert';

DriverJobsModel driverJobsModelFromJson(String str) =>
    DriverJobsModel.fromJson(json.decode(str));

String driverJobsModelToJson(DriverJobsModel data) =>
    json.encode(data.toJson());

class DriverJobsModel {
  DriverJobsModel({
    required this.success,
    required this.jobs,
    required this.pages,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool success;
  List<JobElement> jobs;
  int pages;
  int page;
  int limit;
  int total;

  factory DriverJobsModel.fromJson(Map<String, dynamic> json) =>
      DriverJobsModel(
        success: json["success"],
        jobs: List<JobElement>.from(
            json["jobs"].map((x) => JobElement.fromJson(x))),
        pages: json["pages"],
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
        "pages": pages,
        "page": page,
        "limit": limit,
        "total": total,
      };
}

class JobElement {
  JobElement({
    required this.job,
  });

  JobJob job;

  factory JobElement.fromJson(Map<String, dynamic> json) => JobElement(
        job: JobJob.fromJson(json["job"]),
      );

  Map<String, dynamic> toJson() => {
        "job": job.toJson(),
      };
}

class JobJob {
  JobJob({
    required this.id,
    required this.customerId,
    required this.customerType,
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
    required this.jobImage,
  });

  String id;
  String customerId;
  String customerType;
  Delivery pickUp;
  Delivery delivery;
  String jobType;
  DateTime deliveryDate;
  String deliveryTime;
  String preferredVehicleChoice;
  PackageInfo packageInfo;
  String jobStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  JobImage jobImage;

  factory JobJob.fromJson(Map<String, dynamic> json) => JobJob(
        id: json["_id"],
        customerId: json["customer_id"],
        customerType: json["customer_type"],
        pickUp: Delivery.fromJson(json["pick_up"]),
        delivery: Delivery.fromJson(json["delivery"]),
        jobType: json["job_type"],
        deliveryDate: DateTime.parse(json["delivery_date"]),
        deliveryTime: json["delivery_time"],
        preferredVehicleChoice: json["preferred_vehicle_choice"],
        packageInfo: PackageInfo.fromJson(json["package_info"]),
        jobStatus: json["job_status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        jobImage: JobImage.fromJson(json["job_image"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "customer_id": customerId,
        "customer_type": customerType,
        "pick_up": pickUp.toJson(),
        "delivery": delivery.toJson(),
        "job_type": jobType,
        "delivery_date":
            "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "preferred_vehicle_choice": preferredVehicleChoice,
        "package_info": packageInfo.toJson(),
        "job_status": jobStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "job_image": jobImage.toJson(),
      };
}

class Delivery {
  Delivery({
    required this.loc,
    required this.address,
    required this.name,
    required this.mobile,
    required this.id,
    required this.instruction,
  });

  Loc loc;
  String address;
  String name;
  String mobile;
  String id;
  String instruction;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        loc: Loc.fromJson(json["loc"]),
        address: json["address"],
        name: json["name"],
        mobile: json["mobile"],
        id: json["_id"],
        instruction: json["instruction"],
      );

  Map<String, dynamic> toJson() => {
        "loc": loc.toJson(),
        "address": address,
        "name": name,
        "mobile": mobile,
        "_id": id,
        "instruction": instruction,
      };
}

class Loc {
  Loc({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Loc.fromJson(Map<String, dynamic> json) => Loc(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class JobImage {
  JobImage({
    required this.id,
    required this.url,
  });

  String id;
  String url;

  factory JobImage.fromJson(Map<String, dynamic> json) => JobImage(
        id: json["_id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "url": url,
      };
}

class PackageInfo {
  PackageInfo({
    required this.itemType,
    required this.noOfItems,
    required this.pricePerDeliveryParcel,
    required this.notes,
    required this.id,
  });

  String itemType;
  int noOfItems;
  int pricePerDeliveryParcel;
  String notes;
  String id;

  factory PackageInfo.fromJson(Map<String, dynamic> json) => PackageInfo(
        itemType: json["item_type"],
        noOfItems: json["no_of_items"],
        pricePerDeliveryParcel: json["price_per_delivery_parcel"],
        notes: json["notes"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "item_type": itemType,
        "no_of_items": noOfItems,
        "price_per_delivery_parcel": pricePerDeliveryParcel,
        "notes": notes,
        "_id": id,
      };
}
