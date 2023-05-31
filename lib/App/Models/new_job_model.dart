// To parse this JSON data, do
//
//     final newJobsModel = newJobsModelFromJson(jsonString);

import 'dart:convert';

NewJobsModel newJobsModelFromJson(String str) =>
    NewJobsModel.fromJson(json.decode(str));

String newJobsModelToJson(NewJobsModel data) => json.encode(data.toJson());

class NewJobsModel {
  NewJobsModel({
    required this.success,
    required this.jobsRequests,
    required this.pages,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool success;
  List<JobsRequest> jobsRequests;
  int pages;
  int page;
  int limit;
  int total;

  factory NewJobsModel.fromJson(Map<String, dynamic> json) => NewJobsModel(
        success: json["success"],
        jobsRequests: List<JobsRequest>.from(
            json["jobsRequests"].map((x) => JobsRequest.fromJson(x))),
        pages: json["pages"],
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "jobsRequests": List<dynamic>.from(jobsRequests.map((x) => x.toJson())),
        "pages": pages,
        "page": page,
        "limit": limit,
        "total": total,
      };
}

class JobsRequest {
  JobsRequest({
    required this.data,
    required this.isApplied,
  });

  Data data;
  bool isApplied;

  factory JobsRequest.fromJson(Map<String, dynamic> json) => JobsRequest(
        data: Data.fromJson(json["data"]),
        isApplied: json["is_applied"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "is_applied": isApplied,
      };
}

class Data {
  Data({
    required this.id,
    required this.driverAction,
    required this.job,
    required this.requestId,
  });

  String id;
  int driverAction;
  Job job;
  String requestId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        driverAction: json["driver_action"],
        job: Job.fromJson(json["job"]),
        requestId: json["request_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "driver_action": driverAction,
        "job": job.toJson(),
        "request_id": requestId,
      };
}

class Job {
  Job({
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
    required this.attachment,
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
  Attachment attachment;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
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
        attachment: Attachment.fromJson(json["attachment"]),
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
        "attachment": attachment.toJson(),
      };
}

class Attachment {
  Attachment({
    required this.id,
    required this.imageUrl,
  });

  String id;
  String imageUrl;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["_id"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image_url": imageUrl,
      };
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

  Loc loc;
  String address;
  String addressDetails;
  String name;
  String mobile;
  String instruction;
  String id;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        loc: Loc.fromJson(json["loc"]),
        address: json["address"],
        addressDetails: json["address_details"],
        name: json["name"],
        mobile: json["mobile"],
        instruction: json["instruction"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "loc": loc.toJson(),
        "address": address,
        "address_details": addressDetails,
        "name": name,
        "mobile": mobile,
        "instruction": instruction,
        "_id": id,
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

class PackageInfo {
  PackageInfo({
    required this.itemType,
    required this.noOfItems,
    required this.pricePerMile,
    required this.pricePerDeliveryParcel,
    required this.pricePerMileParcel,
    required this.notes,
    required this.id,
  });

  String itemType;
  int noOfItems;
  int pricePerMile;
  int pricePerDeliveryParcel;
  double pricePerMileParcel;
  String notes;
  String id;

  factory PackageInfo.fromJson(Map<String, dynamic> json) => PackageInfo(
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
