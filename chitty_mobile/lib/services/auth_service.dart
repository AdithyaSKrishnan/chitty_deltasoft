import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  // WINDOWS DESKTOP
  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  // ANDROID EMULATOR
  // static const String baseUrl =
  //     'http://10.0.2.2:8000/api';
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

  required String houseName,
  required String landmark,
  required String village,
  required String taluk,
  required String district,
  required String state,
  required String pincode,

  required String companyName,
  required String officeAddress,
  required String officePhone,
  required String officeLandmark,

  required double latitude,
  required double longitude,

  File? customerPhoto,
  File? addressProof,
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

request.fields['home_address'] = jsonEncode({
  'house_name': houseName,
  'landmark': landmark,
  'village': village,
  'taluk': taluk,
  'district': district,
  'state': state,
  'pincode': pincode,
  'latitude': latitude,
  'longitude': longitude,
});

request.fields['work_address'] = jsonEncode({
  'building_name': companyName,
  'house_name': officeAddress,
  'landmark': officeLandmark,
});

if (customerPhoto != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'customer_photo',
      customerPhoto.path,
    ),
  );
}

if (addressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'address_proof',
      addressProof.path,
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

  required String houseName,
  required String landmark,
  required String village,
  required String taluk,
  required String district,
  required String state,
  required String pincode,
  required String companyName,
required String officeAddress,
required String officePhone,
required String officeLandmark,
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
      'work_address': {

  'building_name': companyName,

  'house_name': officeAddress,

  'landmark': officeLandmark,

  'pincode': officePhone,
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
}