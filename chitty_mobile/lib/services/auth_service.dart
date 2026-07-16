import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  
  
   static const String baseUrl =
      //'https://chittyapi.orianacare.com/api';
      //'http://10.173.97.225:8000/api';
      'http://10.72.160.225:8000/api';
  
  static Future<List<dynamic>> getCustomers() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/customers/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("CUSTOMERS RESPONSE:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}

  static Future<Map<String, dynamic>> login({

    required String username,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/token/'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'access_token',
        data['access'],
      );

      await prefs.setString(
        'refresh_token',
        data['refresh'],
      );

      await prefs.setString(
        'role',
        data['role'],
      );
      print("ROLE = ${data['role']}");

      return {
        'success': true,
        'role': data['role'],
      };
    }

    return {
      'success': false,
      'message':
          data['detail'] ??
              'Login failed',
    };
  }

  static Future<void> logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }
  static Future<List<dynamic>> getRecentCustomers() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(

    Uri.parse(
      '$baseUrl/dashboard/recent-customers/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  if (response.statusCode == 200) {

    return jsonDecode(
      response.body,
    );
  }

  return [];
}

static Future<List<dynamic>> getRecentSubscriptions() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(

    Uri.parse(
      '$baseUrl/dashboard/recent-subscriptions/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  if (response.statusCode == 200) {

    return jsonDecode(
      response.body,
    );
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
  /*required String houseName,
  required String landmark,
  required String village,
  required String taluk,
  required String district,
  required String state,
  required String pincode,*/

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

  final prefs =
      await SharedPreferences.getInstance();
  

  final token =
    prefs.getString('access_token');

  var request = http.MultipartRequest(
  'POST',
  Uri.parse('$baseUrl/customers/'),
);

request.headers['Authorization'] =
    'Bearer $token';

request.fields['full_name'] = fullName;
request.fields['mobile_number'] = mobileNumber;
request.fields['alternate_number'] = alternateNumber;
request.fields['email'] = email;
request.fields['customer_type'] =
    customerType == "Other"
        ? otherCustomerType
        : customerType;

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
  request.files.add(
    await http.MultipartFile.fromPath(
      'customer_photo',
      customerPhoto.path,
    ),
  );
}

if (homeAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'address_proof',
      homeAddressProof.path,
    ),
  );
}

if (currentAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'current_address_proof',
      currentAddressProof.path,
    ),
  );
}

if (workAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'work_address_proof',
      workAddressProof.path,
    ),
  );
}

if (idProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'id_proof',
      idProof.path,
    ),
  );
}
print("===== REQUEST DATA =====");
print(request.fields);

for (var file in request.files) {
  print("FILE: ${file.field}");
}
request.fields['customer_type'] = customerType;
final streamedResponse = await request.send();

final response =
    await http.Response.fromStream(
  streamedResponse,
);

print("Status Code: ${response.statusCode}");
print("Response: ${response.body}");

if (response.statusCode == 201) {
  return jsonDecode(response.body)
      as Map<String, dynamic>;
}

return null;
}
static Future<bool> deleteCustomer(
  int customerId,
) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.delete(

    Uri.parse(
      '$baseUrl/customers/$customerId/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  return response.statusCode == 204;
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

// Current Address
required String currentHouseName,
required String currentBuildingName,
required String currentLandmark,
required String currentVillage,
required String currentTaluk,
required String currentDistrict,
required String currentState,
required String currentPincode,

// Work Address
required String companyName,
required String officeAddress,
required String officeLandmark,
required String workVillage,
required String workTaluk,
required String workDistrict,
required String workState,
required String workPincode,
}) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.put(

    Uri.parse(
      '$baseUrl/customers/$customerId/',
    ),

    headers: {

      'Authorization':
          'Bearer $token',

      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'full_name': fullName,

      'mobile_number': mobileNumber,

      'alternate_number': alternateNumber,

      'email': email,

      'home_address': {

        'house_name': houseName,

        'landmark': landmark,

        'village': village,

        'taluk': taluk,

        'district': district,

        'state': state,

        'pincode': pincode,
      },
      'current_address': {

  'house_name': currentHouseName,

  'building_name': currentBuildingName,

  'landmark': currentLandmark,

  'village': currentVillage,

  'taluk': currentTaluk,

  'district': currentDistrict,

  'state': currentState,

  'pincode': currentPincode,
},

'work_address': {

  'building_name': companyName,

  'house_name': officeAddress,

  'landmark': officeLandmark,

  'village': workVillage,

  'taluk': workTaluk,

  'district': workDistrict,

  'state': workState,

  'pincode': workPincode,
},
    }),
  );

  //print(response.statusCode);
  //print(response.body);
  print("Status Code: ${response.statusCode}");
  print("Response: ${response.body}");
  return response.statusCode == 200;
}
static Future<List<dynamic>> getChitPlans() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/chit-plans/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}

static Future<List<dynamic>> getSubscriptions() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/subscriptions/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
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

  final response = await http.post(
    Uri.parse('$baseUrl/subscriptions/'),
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

  print("Subscription Status Code: ${response.statusCode}");
  print("Subscription Response: ${response.body}");

  return response.statusCode == 201;
}
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

  final response = await http.post(
    Uri.parse('$baseUrl/employees/'),
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

  print(response.statusCode);
  print(response.body);

  return response.statusCode == 201;
}
static Future<List<dynamic>> getEmployees() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/employees/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  print("EMPLOYEES API:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}
static Future<bool> toggleEmployeeStatus(
  int employeeId,
) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.post(

    Uri.parse(
      '$baseUrl/employees/$employeeId/toggle_status/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  print(response.body);

  return response.statusCode == 200;
}
static Future<bool> updateEmployee({
  required int employeeId,
  required String fullName,
  required String email,
  required String phoneNumber,
  required String role,
}) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.put(

    Uri.parse(
      '$baseUrl/employees/$employeeId/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,

    }),
  );

  print(response.body);
  print("UPDATE STATUS: ${response.statusCode}");
  print("UPDATE BODY: ${response.body}");
  return response.statusCode == 200;
}
static Future<Map<String, dynamic>> getAgentDashboard() async {
  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/agent-dashboard/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("AGENT DASHBOARD:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return {};
}
static Future<bool> approveCustomer(int customerId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('access_token');

  final response = await http.post(
    Uri.parse('$baseUrl/customers/$customerId/approve/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return response.statusCode == 200;
}
static Future<String?> getRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}
}