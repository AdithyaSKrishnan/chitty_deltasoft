import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 🟢 LIVE PRODUCTION SERVER
  static const String baseUrl = 'https://chittyapi.orianacare.com/api';

  /// Connection timeout duration — prevents hanging on slow/bad networks
  static const Duration _connectTimeout = Duration(seconds: 20);

  /// Read timeout — prevents hanging while waiting for response
  static const Duration _readTimeout = Duration(seconds: 30);

  // ---------------------------------------------------------------------------
  // HELPER: Safe HTTP GET with timeout and error handling
  // ---------------------------------------------------------------------------
  static Future<http.Response?> _safeGet(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_readTimeout);
      return response;
    } on SocketException catch (e) {
      print('SocketException [GET $url]: $e');
    } on HttpException catch (e) {
      print('HttpException [GET $url]: $e');
    } on FormatException catch (e) {
      print('FormatException [GET $url]: $e');
    } catch (e) {
      print('Unknown error [GET $url]: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // HELPER: Safe HTTP POST with timeout and error handling
  // ---------------------------------------------------------------------------
  static Future<http.Response?> _safePost(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(_readTimeout);
      return response;
    } on SocketException catch (e) {
      print('SocketException [POST $url]: $e');
    } on HttpException catch (e) {
      print('HttpException [POST $url]: $e');
    } on FormatException catch (e) {
      print('FormatException [POST $url]: $e');
    } catch (e) {
      print('Unknown error [POST $url]: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // HELPER: Safe HTTP PATCH with timeout and error handling
  // ---------------------------------------------------------------------------
  static Future<http.Response?> _safePatch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await http
          .patch(Uri.parse(url), headers: headers, body: body)
          .timeout(_readTimeout);
      return response;
    } on SocketException catch (e) {
      print('SocketException [PATCH $url]: $e');
    } on HttpException catch (e) {
      print('HttpException [PATCH $url]: $e');
    } on FormatException catch (e) {
      print('FormatException [PATCH $url]: $e');
    } catch (e) {
      print('Unknown error [PATCH $url]: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // HELPER: Safe HTTP DELETE with timeout and error handling
  // ---------------------------------------------------------------------------
  static Future<http.Response?> _safeDelete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(_readTimeout);
      return response;
    } on SocketException catch (e) {
      print('SocketException [DELETE $url]: $e');
    } on HttpException catch (e) {
      print('HttpException [DELETE $url]: $e');
    } on FormatException catch (e) {
      print('FormatException [DELETE $url]: $e');
    } catch (e) {
      print('Unknown error [DELETE $url]: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // AUTH
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _safePost(
        '$baseUrl/token/',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response == null) {
        return {
          'success': false,
          'message': 'Network error. Please check your internet connection.',
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        await prefs.setString('role', data['role']);
        print("ROLE = ${data['role']}");
        return {'success': true, 'role': data['role']};
      }

      return {
        'success': false,
        'message': data['detail'] ?? 'Login failed. Please try again.',
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  // ---------------------------------------------------------------------------
  // CUSTOMERS
  // ---------------------------------------------------------------------------

  static Future<List<dynamic>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/customers/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("CUSTOMERS RESPONSE: ${response?.body}");

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>?> createCustomer({
    required String fullName,
    required String mobileNumber,
    required String alternateNumber,
    required String email,
    required String customerType,
    required String otherCustomerType,

    // Home Address
    required String houseName,
    required String landmark,
    required String village,
    required String taluk,
    required String district,
    required String state,
    required String pincode,
    required double homeLatitude,
    required double homeLongitude,

    // Current Address
    required String currentHouseName,
    required String currentLandmark,
    required String currentVillage,
    required String currentTaluk,
    required String currentDistrict,
    required String currentState,
    required String currentPincode,
    required double currentLatitude,
    required double currentLongitude,

    // Work Address
    required String companyName,
    required String officeAddress,
    required String workLandmark,
    required String workVillage,
    required String workTaluk,
    required String workDistrict,
    required String workState,
    required String workPincode,
    required double workLatitude,
    required double workLongitude,

    // Photos
    File? customerPhoto,
    File? homeAddressProof,
    File? currentAddressProof,
    File? workAddressProof,
    File? idProof,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/customers/'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      final resolvedType =
          customerType == "Other" ? otherCustomerType : customerType;
      request.fields['full_name'] = fullName;
      request.fields['mobile_number'] = mobileNumber;
      if (alternateNumber.trim().isNotEmpty) {
        request.fields['alternate_number'] = alternateNumber;
      }
      if (email.trim().isNotEmpty) {
        request.fields['email'] = email;
      }
      request.fields['customer_type'] =
          resolvedType.trim().isNotEmpty ? resolvedType : "Customer";

      request.fields['home_address'] = jsonEncode({
        'house_name': houseName,
        'building_name': '',
        'landmark': landmark,
        'village': village,
        'taluk': taluk,
        'district': district,
        'state': state,
        'pincode': pincode,
        'latitude': homeLatitude,
        'longitude': homeLongitude,
      });

      request.fields['current_address'] = jsonEncode({
        'house_name': currentHouseName,
        'building_name': '',
        'landmark': currentLandmark,
        'village': currentVillage,
        'taluk': currentTaluk,
        'district': currentDistrict,
        'state': currentState,
        'pincode': currentPincode,
        'latitude': currentLatitude,
        'longitude': currentLongitude,
      });

      request.fields['work_address'] = jsonEncode({
        'building_name': companyName,
        'house_name': officeAddress,
        'landmark': workLandmark,
        'village': workVillage,
        'taluk': workTaluk,
        'district': workDistrict,
        'state': workState,
        'pincode': workPincode,
        'latitude': workLatitude,
        'longitude': workLongitude,
      });

      if (customerPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'customer_photo', customerPhoto.path));
      }
      if (homeAddressProof != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'address_proof', homeAddressProof.path));
      }
      if (currentAddressProof != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'current_address_proof', currentAddressProof.path));
      }
      if (workAddressProof != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'work_address_proof', workAddressProof.path));
      }
      if (idProof != null) {
        request.files.add(
            await http.MultipartFile.fromPath('id_proof', idProof.path));
      }

      print("===== REQUEST DATA =====");
      print(request.fields);
      for (var file in request.files) {
        print("FILE: ${file.field}");
      }

      final streamedResponse = await request.send().timeout(_readTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('createCustomer error: $e');
    }
    return null;
  }

  static Future<bool> deleteCustomer(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeDelete(
      '$baseUrl/customers/$customerId/',
      headers: {'Authorization': 'Bearer $token'},
    );

    return response != null && response.statusCode == 204;
  }

  static Future<bool> updateCustomer({
    required int customerId,
    required String fullName,
    required String mobileNumber,
    required String alternateNumber,
    required String email,

    // Home Address
    required String houseName,
    required String landmark,
    required String village,
    required String taluk,
    required String district,
    required String state,
    required String pincode,
    String? homeGoogleMapsLink,
    double? homeLatitude,
    double? homeLongitude,

    // Current Address
    required String currentHouseName,
    required String currentBuildingName,
    required String currentLandmark,
    required String currentVillage,
    required String currentTaluk,
    required String currentDistrict,
    required String currentState,
    required String currentPincode,
    String? currentGoogleMapsLink,
    double? currentLatitude,
    double? currentLongitude,

    // Work Address
    required String companyName,
    required String officeAddress,
    required String officeLandmark,
    required String workVillage,
    required String workTaluk,
    required String workDistrict,
    required String workState,
    required String workPincode,
    String? workGoogleMapsLink,
    double? workLatitude,
    double? workLongitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final Map<String, dynamic> bodyPayload = {
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'alternate_number': alternateNumber,
      'email': email,
    };

    bodyPayload['home_address'] = {
      'house_name': houseName,
      'landmark': landmark,
      'village': village,
      'taluk': taluk,
      'district': district,
      'state': state,
      'pincode': pincode,
      if (homeGoogleMapsLink != null && homeGoogleMapsLink.isNotEmpty)
        'google_maps_link': homeGoogleMapsLink,
      if (homeLatitude != null) 'latitude': homeLatitude,
      if (homeLongitude != null) 'longitude': homeLongitude,
    };

    bodyPayload['current_address'] = {
      'house_name': currentHouseName,
      'building_name': currentBuildingName,
      'landmark': currentLandmark,
      'village': currentVillage,
      'taluk': currentTaluk,
      'district': currentDistrict,
      'state': currentState,
      'pincode': currentPincode,
      if (currentGoogleMapsLink != null && currentGoogleMapsLink.isNotEmpty)
        'google_maps_link': currentGoogleMapsLink,
      if (currentLatitude != null) 'latitude': currentLatitude,
      if (currentLongitude != null) 'longitude': currentLongitude,
    };

    bodyPayload['work_address'] = {
      'building_name': companyName,
      'house_name': officeAddress,
      'landmark': officeLandmark,
      'village': workVillage,
      'taluk': workTaluk,
      'district': workDistrict,
      'state': workState,
      'pincode': workPincode,
      if (workGoogleMapsLink != null && workGoogleMapsLink.isNotEmpty)
        'google_maps_link': workGoogleMapsLink,
      if (workLatitude != null) 'latitude': workLatitude,
      if (workLongitude != null) 'longitude': workLongitude,
    };

    final response = await _safePatch(
      '$baseUrl/customers/$customerId/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bodyPayload),
    );

    print("Status Code: ${response?.statusCode}");
    print("Response: ${response?.body}");
    return response != null &&
        (response.statusCode == 200 || response.statusCode == 202);
  }

  static Future<bool> updateCustomerKyc({
    required int customerId,
    File? customerPhoto,
    File? addressProof,
    File? idProof,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/customers/$customerId/'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      if (customerPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'customer_photo', customerPhoto.path));
      }
      if (addressProof != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'address_proof', addressProof.path));
      }
      if (idProof != null) {
        request.files.add(
            await http.MultipartFile.fromPath('id_proof', idProof.path));
      }

      final streamed = await request.send().timeout(_readTimeout);
      final response = await http.Response.fromStream(streamed);

      print("KYC Update Status: ${response.statusCode}");
      print("KYC Update Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('updateCustomerKyc error: $e');
      return false;
    }
  }

  static Future<bool> approveCustomer(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customers/$customerId/approve/',
      headers: {'Authorization': 'Bearer $token'},
    );

    return response != null && response.statusCode == 200;
  }

  // ---------------------------------------------------------------------------
  // DASHBOARD
  // ---------------------------------------------------------------------------

  static Future<List<dynamic>> getRecentCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/dashboard/recent-customers/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<List<dynamic>> getRecentSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/dashboard/recent-subscriptions/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>> getAgentDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/agent-dashboard/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("AGENT DASHBOARD: ${response?.body}");

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  // ---------------------------------------------------------------------------
  // CHIT PLANS
  // ---------------------------------------------------------------------------

  static Future<List<dynamic>> getChitPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/chit-plans/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------------------------------------------------------------------
  // SUBSCRIPTIONS
  // ---------------------------------------------------------------------------

  static Future<List<dynamic>> getSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/subscriptions/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> createSubscription({
    required int customerId,
    required int chitPlanId,
    required String joinedDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/subscriptions/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'customer': customerId,
        'chit_plan': chitPlanId,
        'joined_date': joinedDate,
      }),
    );

    print("Subscription Status Code: ${response?.statusCode}");
    print("Subscription Response: ${response?.body}");

    return response != null && response.statusCode == 201;
  }

  // ---------------------------------------------------------------------------
  // EMPLOYEES
  // ---------------------------------------------------------------------------

  static Future<bool> createEmployee({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/employees/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'role': role,
      }),
    );

    print("Create employee: ${response?.statusCode} ${response?.body}");
    return response != null && response.statusCode == 201;
  }

  static Future<List<dynamic>> getEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/employees/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("EMPLOYEES API: ${response?.body}");

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> toggleEmployeeStatus(int employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/employees/$employeeId/toggle_status/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Toggle employee: ${response?.body}");
    return response != null && response.statusCode == 200;
  }

  static Future<bool> updateEmployee({
    required int employeeId,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
    String? password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final payload = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
    };
    if (password != null && password.trim().isNotEmpty) {
      payload['password'] = password.trim();
    }

    final response = await _safePatch(
      '$baseUrl/employees/$employeeId/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    print("UPDATE STATUS: ${response?.statusCode}");
    print("UPDATE BODY: ${response?.body}");
    return response != null &&
        (response.statusCode == 200 || response.statusCode == 202);
  }

  // ---------------------------------------------------------------------------
  // CUSTOMER EDIT REQUESTS
  // ---------------------------------------------------------------------------

  static Future<bool> hasPendingEditRequest(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/customer-edit-requests/?customer=$customerId&status=Pending',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.isNotEmpty;
    }
    return false;
  }

  static Future<bool> createEditRequest(int customerId, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-edit-requests/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'customer': customerId, 'reason': reason}),
    );

    return response != null && response.statusCode == 201;
  }

  static Future<List<dynamic>> getPendingEditRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safeGet(
      '$baseUrl/customer-edit-requests/?status=Pending',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> toggleCustomerEditPermission(
      int customerId, bool enable) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePatch(
      '$baseUrl/customers/$customerId/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'edit_enabled': enable}),
    );

    return response != null &&
        (response.statusCode == 200 || response.statusCode == 202);
  }

  static Future<bool> approveEditRequest(int requestId, int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-edit-requests/$requestId/approve/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Approve Edit Request status: ${response?.statusCode}");
    print("Approve Edit Request body: ${response?.body}");
    return response != null &&
        (response.statusCode == 200 || response.statusCode == 202);
  }

  static Future<bool> rejectEditRequest(int requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-edit-requests/$requestId/reject/',
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Reject Edit Request status: ${response?.statusCode}");
    print("Reject Edit Request body: ${response?.body}");
    return response != null &&
        (response.statusCode == 200 || response.statusCode == 202);
  }

  // ---------------------------------------------------------------------------
  // CUSTOMER DELETE REQUESTS
  // ---------------------------------------------------------------------------

  static Future<bool> createDeleteRequest(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-delete-requests/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'customer': customerId}),
    );

    return response != null && response.statusCode == 201;
  }

  static Future<List<dynamic>> getDeleteRequests({int? customerId, String? status}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    String url = '$baseUrl/customer-delete-requests/';
    List<String> params = [];
    if (customerId != null) params.add('customer=$customerId');
    if (status != null) params.add('status=$status');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final response = await _safeGet(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> approveDeleteRequest(int requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-delete-requests/$requestId/approve/',
      headers: {'Authorization': 'Bearer $token'},
    );

    return response != null && (response.statusCode == 200 || response.statusCode == 202);
  }

  static Future<bool> rejectDeleteRequest(int requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await _safePost(
      '$baseUrl/customer-delete-requests/$requestId/reject/',
      headers: {'Authorization': 'Bearer $token'},
    );

    return response != null && (response.statusCode == 200 || response.statusCode == 202);
  }
}