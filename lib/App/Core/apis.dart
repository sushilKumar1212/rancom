import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:places_service/places_service.dart';
import 'package:thecourierapp/App/Models/create_job_modal.dart';
import 'package:thecourierapp/App/Models/driver_jobs_model.dart';
import 'package:thecourierapp/App/Models/job_model.dart';

import 'endpoints.dart';

class Apis {
  static String baseUrl = 'http://thecarcourierapi.ibyteworkshop.com';

  //Onboard
  static Future<Response> onboardApi() async {
    final Response response = await get(
      Uri.parse(baseUrl + onboard),
    );
    return response;
  }

  //Driver SignUp
  static Future<Response> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final Response response = await post(
      Uri.parse(baseUrl + driverSignUp),
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "confirm_password": password,
      },
    );
    return response;
  }

  // Driver Login
  static Future<Response> driverLoginApi({
    required String email,
    required String password,
    required String devicetoken,
  }) async {
    final Response response = await post(
      Uri.parse(baseUrl + driverLogin),
      body: {
        "email": email,
        "password": password,
        'device_token': devicetoken,
      },
    );
    return response;
  }

  //Verify Otp
  static Future<Response> verifyOtpApi({
    required String email,
    required String otp,
  }) async {
    log("OtP: $otp");
    final Response response = await patch(
      Uri.parse(baseUrl + verifyOtp),
      body: {
        "email": email,
        "otp": otp,
      },
    );
    return response;
  }

  static Future<Response> verifyChnagePasswordApi({
    required String email,
    required String otp,
  }) async {
    log("OtP: $otp");
    final Response response = await post(
      Uri.parse(baseUrl + verifyForgotPassword),
      body: {
        "email": email,
        "otp": otp,
      },
    );
    return response;
  }

  // Resend Otp
  static Future<Response> resendOtpApi({
    required String email,
    String action = "verify_email",
  }) async {
    final Response response = await post(
      Uri.parse(baseUrl + resendOtp),
      body: {
        "email": email,
        "action": action,
      },
    );
    return response;
  }

  // Update Phone Number
  static Future<Response> updatePhoneNumber({
    required String token,
    required String phoneNumber,
  }) async {
    final Response response =
        await patch(Uri.parse(baseUrl + phoenUpdate), body: {
      "phone_number": phoneNumber,
    }, headers: {
      "Authorization": "Bearer $token"
    });
    return response;
  }

  //Select Vehicle Type or Hustler Type Api
  static Future<Response> selectQuestionData({
    required String token,
    required String question,
    required String answer,
  }) async {
    final Response response = await post(
      Uri.parse(baseUrl + selectQuestion),
      body: jsonEncode({
        "question_name": question,
        "options_names": [answer],
      }),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    return response;
  }

  //Get Personal Info
  static Future<Response> getPersonalDetails({
    required String token,
  }) async {
    final Response response = await get(
      Uri.parse(baseUrl + getPersonalInfo),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  //Update Personal Info
  static Future<Response> updatePersonalDetails({
    required String token,
    required String address,
    required String dateOfBirth,
    required String city,
    required String arealocality,
    required String postalCode,
    required String country,
    required String nationalInsuranceNumber,
  }) async {
    final Response response = await put(
      Uri.parse(baseUrl + updatePersonalInfo),
      body: {
        "address_1": address,
        "date_of_birth": dateOfBirth,
        "national_insurance_number": nationalInsuranceNumber,
        "city": city,
        "pin_code": postalCode,
        "country": "UK",
        "address_2": arealocality,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  //Get Vehicle Details
  static Future<Response> getVehicleDetails({
    required String token,
  }) async {
    final Response response = await get(
      Uri.parse(baseUrl + getvehicleDetails),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  //Update Vehicle Details
  static Future<Response> updateVehicleDetaisl({
    required String token,
    required String frontPic,
    required String backPic,
    required String leftPic,
    required String rightPic,
    required String vehicleRegistration,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleYear,
  }) async {
    // make multipart request
    final request = MultipartRequest(
      'PUT',
      Uri.parse(baseUrl + updateVehicleDetails),
    );
    var header = {
      "Authorization": "Bearer $token",
    };
    request.headers.addAll(header);
    // add file to multipart
    if (!frontPic.startsWith("http")) {
      request.files.add(
        await MultipartFile.fromPath(
          'front_pic',
          frontPic,
        ),
      );
    }
    if (!backPic.startsWith("http")) {
      request.files.add(
        await MultipartFile.fromPath(
          'rear_pic',
          backPic,
        ),
      );
    }
    if (!leftPic.startsWith("http")) {
      request.files.add(
        await MultipartFile.fromPath(
          'left_pic',
          leftPic,
        ),
      );
    }
    if (!rightPic.startsWith("http")) {
      request.files.add(
        await MultipartFile.fromPath(
          'right_pic',
          rightPic,
        ),
      );
    }
    request.fields.addAll({
      "registration": vehicleRegistration,
      "make": vehicleMake,
      "model": vehicleModel,
      "year": vehicleYear,
    });
    // send
    final response = await request.send();

    return Response(
      await response.stream.bytesToString(),
      response.statusCode,
    );
  }

  //Get Document Details
  static Future<Response> getDocumentsDetails({
    required String token,
  }) async {
    final Response response = await get(
      Uri.parse(baseUrl + getDocumentDetails),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  //Update Document Details
  static Future<Response> updateDocumentInfo({
    required String token,
    required String proofofAddress,
    required String frontdrivingLicence,
    required String backdrivingLicence,
    required String insurance,
  }) async {
    // make multipart request
    final request = MultipartRequest(
      'PUT',
      Uri.parse(baseUrl + updateDocumentDetails),
    );
    var header = {
      "Authorization": "Bearer $token",
    };
    request.headers.addAll(header);
    // add file to multipart
    if (!proofofAddress.startsWith("http")) {
      log('proofofAddress: $proofofAddress');
      request.files.add(
        await MultipartFile.fromPath(
          'proof_of_address',
          proofofAddress,
        ),
      );
    }
    if (!frontdrivingLicence.startsWith("http")) {
      log('frontdrivingLicence: $frontdrivingLicence');
      request.files.add(
        await MultipartFile.fromPath(
          'driving_license_front_pic',
          frontdrivingLicence,
        ),
      );
    }
    if (!backdrivingLicence.startsWith("http")) {
      log('backdrivingLicence: $backdrivingLicence');
      request.files.add(
        await MultipartFile.fromPath(
          'driving_license_rear_pic',
          backdrivingLicence,
        ),
      );
    }
    if (!insurance.startsWith("http")) {
      log('insurance: $insurance');
      request.files.add(
        await MultipartFile.fromPath(
          'insurance_document',
          insurance,
        ),
      );
    }

    // send
    final response = await request.send();

    return Response(
      await response.stream.bytesToString(),
      response.statusCode,
    );
  }

  //Get Bank Details
  static Future<Response> getBankingDetails({
    required String token,
  }) async {
    final Response response = await get(
      Uri.parse(baseUrl + getBankDetails),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  //Update Bank Details
  static Future<Response> updateBankingDetails({
    required String token,
    required String sortCode,
    required String accountNumber,
    required String bankName,
    required String nameAsAppears,
  }) async {
    final Response response = await put(
      Uri.parse(baseUrl + updateBankDetails),
      body: {
        "sort_code": sortCode,
        "account_number": accountNumber,
        "bank_name": bankName,
        "name_as_appears": nameAsAppears,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  // Update Profile Pic
  static Future<Response> updateProfilePic({
    required String token,
    required File profilePic,
  }) async {
    final request = MultipartRequest(
      'PATCH',
      Uri.parse(baseUrl + updateProfileImage),
    );
    var header = {
      "Authorization": "Bearer $token",
    };
    request.headers.addAll(header);
    // add file to multipart

    request.files.add(
      await MultipartFile.fromPath(
        'profile',
        profilePic.path,
      ),
    );

    // send
    final response = await request.send();

    return Response(
      await response.stream.bytesToString(),
      response.statusCode,
    );
  }

  //Driver on/off
  static Future<Response> driveronoffDuty({
    required String token,
    required bool status,
  }) async {
    final response = await patch(
      Uri.parse(baseUrl + driveronoff),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "is_on_duty": status,
      }),
    );
    return response;
  }

  // Reset Password
  static Future<Response> resetPasswordApi({
    required String token,
    required String password,
  }) async {
    final response = await patch(
      Uri.parse(baseUrl + resetPassword),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'new_password': password,
        'confirm_new_password': password,
      }),
    );
    return response;
  }

  //Change Password
  static Future<Response> changePasswordApi({
    required String oldpassword,
    required String newpassword,
    required String token,
  }) async {
    final response = await patch(
      Uri.parse(baseUrl + resetPassword),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'old_password': oldpassword,
        'new_password': newpassword,
        'confirm_new_password': newpassword,
      }),
    );
    return response;
  }

  static final placeapi = PlacesService();
  // Get Places List from search
  static Future<List<Map<String, dynamic>>> searchPlaces(String search) async {
    placeapi.initialize(apiKey: 'AIzaSyAdOFwxCv9unC7HVDU7B0yIFWZzkNW-oBo');
    final data = await placeapi.getAutoComplete(search);
    List<Map<String, dynamic>> places = [];
    for (var i = 0; i < data.length; i++) {
      places.add({
        "title": data[i].mainText ?? "",
        "subtitle": data[i].description ?? "",
        'id': data[i].placeId,
      });
    }
    return places;
  }

  // Customer Login
  static Future<Response> customerLoginApi({
    required String email,
    required String password,
    required String devicetoken,
  }) async {
    final response = await post(
      Uri.parse(baseUrl + customerLogin),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_token': devicetoken,
      }),
    );
    return response;
  }

  // Driver Logout
  static Future<Response> logoutApi({
    required String token,
    required String deviceToken,
  }) async {
    final response = await delete(
      Uri.parse(baseUrl + logout),
      body: {
        'device_token': deviceToken,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response;
  }

  // Update Location
  static Future<Response> updateLocationApi({
    required String token,
    required double lat,
    required double long,
    bool isCustomer = false,
  }) async {
    log("isCustomer $isCustomer");
    final response = await patch(
      Uri.parse(
          baseUrl + (isCustomer ? updateCustomerLocation : updateLocation)),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "longitude": long,
        "latitude": lat,
      }),
    );
    return response;
  }

  //Create Job Request
  static Future<Response> createJobApi({
    required CreateJobModal model,
    required String token,
    required String image,
  }) async {
    final request = MultipartRequest(
      'POST',
      Uri.parse(baseUrl + creatrJob),
    );
    request.fields.addAll(
        model.toJson().map((key, value) => MapEntry(key, value.toString())));
    if (image.isNotEmpty) {
      request.files.add(
        await MultipartFile.fromPath(
          'image',
          image,
        ),
      );
    }
    request.headers.addAll({
      "Authorization": "Bearer $token",
    });
    return await request.send().then((response) async {
      return Response(
        await response.stream.bytesToString(),
        response.statusCode,
      );
    });
  }

  //Get Job Request
  static Future<JobsModel> getJobsApi({
    required int page,
    required String status,
  }) async {
    final response = await post(
      Uri.parse('$baseUrl$getJobs?page=$page&limit=10'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
      body: jsonEncode({
        "job_status": status,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jobsModelFromJson(response.body);
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  //Get Job Request of Driver
  static Future<DriverJobsModel> getDriverJobsApi({
    required int page,
    required String status,
  }) async {
    final response = await post(
      Uri.parse('$baseUrl$getdriveJobs?page=$page&limit=10'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
      body: jsonEncode({
        "job_status": status,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonDecode(response.body)['success'] == true) {
        final model = driverJobsModelFromJson(response.body);
        return model;
      }
      return DriverJobsModel(
        success: true,
        jobs: [],
        pages: 1,
        page: 1,
        limit: 1,
        total: 1,
      );
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // Get Driver Notifications
  static Future<Response> getNotificationApi() async {
    final response = await get(
      Uri.parse('$baseUrl$getNotifications'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to load Notifications');
    }
  }

  // Get New Job Request
  static Future<Response> getNewjobsApi() async {
    final response = await get(
      Uri.parse('$baseUrl$getNewJobs'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // Apply For Job
  static Future<Response> applyJobApi(String jobId) async {
    final response = await post(
      Uri.parse('$baseUrl$applyJob$jobId'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to apply for job');
    }
  }

  // Get nearby Drivers
  static Future<Response> getNearbyDriversApis({
    String name = '',
    String vehicleType = '',
  }) async {
    final response = await post(
      Uri.parse('$baseUrl$getNearByDrivers'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
      body: jsonEncode({
        "driver_name": name,
        "vehicle_type": vehicleType,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to apply for job');
    }
  }

  // Reply job request
  static Future<Response> replyJobApi({
    bool isAccept = false,
    required String jobRequestId,
  }) async {
    final response = await post(
      Uri.parse('$baseUrl$replyJob'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "request_id": jobRequestId,
        "reply_status": isAccept ? 1 : 2,
      }),
    );
    return response;
  }

  //Send Job Request
  static Future<Response> sendJobRequest({
    required String jobId,
    required String driverId,
  }) async {
    final response = await post(
      Uri.parse('$baseUrl$inviteDriver'),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "driver_id": driverId,
        "job_id": jobId,
      }),
    );
    return response;
  }

  // Get Summary
  static Future<Response> getSummary() async {
    final response = await get(
      Uri.parse("$baseUrl/drivers/summary"),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    return response;
  }

  // Delete Job
  static Future<Response> deleteJobApi({
    required String jobId,
  }) async {
    final response = await delete(
      Uri.parse("$baseUrl/jobs/$jobId"),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    return response;
  }

  // Delete Driver Notifications
  static Future<Response> deleteDriverNotifications() async {
    final response = await delete(
      Uri.parse("$baseUrl/drivers/notifications"),
      headers: {
        "Authorization": "Bearer ${GetStorage().read('token').toString()}",
      },
    );
    return response;
  }
}
