import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ApiService {
  // User Register function
  static Future<bool> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response.statusCode == 200;
  }

  // User Login function
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      print("The toke is ->  $token");
      await AuthService.saveToken(token);
      return true;
    }
    return false;
  }

  //Getting all tasks
  static Future<List<dynamic>> fetchTasks() async {
    final token = await AuthService.getToken();
    print("The token is $token");
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/task/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> createTask(String title, String description) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/task/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"title": title, "description": description}),
    );
    return response.statusCode == 200;
  }

  static Future<dynamic> updateTask(
    int taskId,
    String title,
    String description,
    bool isCompleted,
  ) async {
    final token = await AuthService.getToken();
    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/api/task/$taskId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "isCompleted": isCompleted,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteTask(int taskId) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/api/task/$taskId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response.statusCode == 200;
  }
}
