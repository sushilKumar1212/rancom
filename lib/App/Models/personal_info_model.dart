// To parse this JSON data, do
//
//     final personalInfoModel = personalInfoModelFromJson(jsonString);

import 'dart:convert';

PersonalInfoModel personalInfoModelFromJson(String str) =>
    PersonalInfoModel.fromJson(json.decode(str));

class PersonalInfoModel {
  PersonalInfoModel({
    required this.success,
    required this.status,
    required this.driver,
  });

  bool success;
  String status;
  Driver driver;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      PersonalInfoModel(
        success: json["success"],
        status: json["status"],
        driver: Driver.fromJson(json["driver"]),
      );
}

class Driver {
  Driver({
    required this.loc,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.isPhoneNumberUpdated,
    required this.isPhoneNumberVerified,
    required this.isPersonalInfoCompleted,
    required this.isVehicleInfoCompleted,
    required this.isDocumentsInfoCompleted,
    required this.isBankingDetailsCompleted,
    required this.isAllProfileCompleted,
    required this.isOnBoardingCompleted,
    required this.noOfQuestionsAnswered,
    required this.isOnDuty,
    required this.verifyByAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNumber,
    required this.vehicleCapacity,
    required this.vehicleType,
    required this.address,
    required this.dateOfBirth,
    required this.nationalInsuranceNumber,
    required this.statusByAdmin,
    required this.rejectionReason,
    required this.address1,
    required this.address2,
    required this.city,
    required this.country,
    required this.pinCode,
    required this.imageUrl,
  });

  Loc loc;
  String id;
  String firstName;
  String lastName;
  String email;
  bool isEmailVerified;
  bool isPhoneNumberUpdated;
  bool isPhoneNumberVerified;
  bool isPersonalInfoCompleted;
  bool isVehicleInfoCompleted;
  bool isDocumentsInfoCompleted;
  bool isBankingDetailsCompleted;
  bool isAllProfileCompleted;
  bool isOnBoardingCompleted;
  int noOfQuestionsAnswered;
  bool isOnDuty;
  bool verifyByAdmin;
  DateTime createdAt;
  DateTime updatedAt;
  String? phoneNumber;
  int vehicleCapacity;
  String vehicleType;
  String? address;
  DateTime? dateOfBirth;
  String? nationalInsuranceNumber;
  int statusByAdmin;
  String rejectionReason;
  String? address1;
  String? address2;
  String? city;
  String? country;
  String? pinCode;
  String? imageUrl;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        loc: Loc.fromJson(json["loc"]),
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isEmailVerified: json["is_email_verified"],
        isPhoneNumberUpdated: json["is_phone_number_updated"],
        isPhoneNumberVerified: json["is_phone_number_verified"],
        isPersonalInfoCompleted: json["is_personal_info_completed"],
        isVehicleInfoCompleted: json["is_vehicle_info_completed"],
        isDocumentsInfoCompleted: json["is_documents_info_completed"],
        isBankingDetailsCompleted: json["is_banking_details_completed"],
        isAllProfileCompleted: json["is_all_profile_completed"],
        isOnBoardingCompleted: json["is_on_boarding_completed"],
        noOfQuestionsAnswered: json["no_of_questions_answered"],
        isOnDuty: json["is_on_duty"],
        verifyByAdmin: json["verify_by_admin"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        phoneNumber: json["phone_number"],
        vehicleCapacity: json["vehicle_capacity"],
        vehicleType: json["vehicle_type"],
        address: json["address"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        nationalInsuranceNumber: json["national_insurance_number"],
        statusByAdmin: json["status_by_admin"] ?? 0,
        rejectionReason: json["rejection_reason"] ?? "",
        address1: json["address_1"] ?? "",
        address2: json["address_2"] ?? "",
        city: json["city"] ?? "",
        country: json["country"] ?? "",
        pinCode: json["pin_code"] ?? "",
        imageUrl: json["imageUrl"],
      );
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
