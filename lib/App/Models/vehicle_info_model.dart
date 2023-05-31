// To parse this JSON data, do
//
//     final driverVehicleInfo = driverVehicleInfoFromJson(jsonString);

import 'dart:convert';

DriverVehicleInfo driverVehicleInfoFromJson(String str) =>
    DriverVehicleInfo.fromJson(json.decode(str));

String driverVehicleInfoToJson(DriverVehicleInfo data) =>
    json.encode(data.toJson());

class DriverVehicleInfo {
  DriverVehicleInfo({
    required this.success,
    required this.vehicle,
  });

  bool success;
  Vehicle vehicle;

  factory DriverVehicleInfo.fromJson(Map<String, dynamic> json) =>
      DriverVehicleInfo(
        success: json["success"],
        vehicle: Vehicle.fromJson(json["vehicle"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "vehicle": vehicle.toJson(),
      };
}

class Vehicle {
  Vehicle({
    required this.id,
    required this.registration,
    required this.make,
    required this.model,
    required this.year,
    required this.driverId,
    required this.v,
    required this.attachments,
  });

  String id;
  String registration;
  String make;
  String model;
  String year;
  String driverId;
  int v;
  List<Attachment> attachments;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["_id"],
        registration: json["registration"],
        make: json["make"],
        model: json["model"],
        year: json["year"],
        driverId: json["driver_id"],
        v: json["__v"],
        attachments: List<Attachment>.from(
            json["attachments"].map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "registration": registration,
        "make": make,
        "model": model,
        "year": year,
        "driver_id": driverId,
        "__v": v,
        "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
      };
}

class Attachment {
  Attachment({
    required this.id,
    required this.type,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.path,
    required this.vehicleId,
    required this.v,
  });

  String id;
  String type;
  String name;
  String fileName;
  String mimeType;
  String path;
  String vehicleId;
  int v;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["_id"],
        type: json["type"],
        name: json["name"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        path: json["path"],
        vehicleId: json["vehicle_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "path": path,
        "vehicle_id": vehicleId,
        "__v": v,
      };
}
