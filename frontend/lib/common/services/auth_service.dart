// lib/common/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000/auth";
  String? token;
  

  Future<Map<String, dynamic>> register(String email, String pwd, String confirm_pwd) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "pwd": pwd, "confirm_pwd": confirm_pwd}),
    );
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>?> login(String email, String pwd, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "pwd": pwd}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      token = data['data']['token']; 
      return data;
    } else {
      print("Login failed: ${response.body}");
      return null;
    }
  }
  
  void logout(BuildContext context) {
    token = null;
    context.go('/login');
  }
  
  Future<bool> checkAuthStatus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/check-auth'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isAuthenticated'] ?? false;
    }
    return false;
  }
  
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/current-user'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token",},
      
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
  
  Future<Map<String, dynamic>> completeProfile(int userId, String fullName, String phone, String department) async {
    final response = await http.post(
      Uri.parse('$baseUrl/complete-profile/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "phone": phone,
        "department": department,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to complete profile. Code: ${response.statusCode}");
    }
  }
}

final AuthService authService = AuthService();