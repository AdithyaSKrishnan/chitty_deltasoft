import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/dashboard/stats/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load dashboard stats');
  }
}