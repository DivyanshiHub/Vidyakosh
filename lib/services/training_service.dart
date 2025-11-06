import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/training_model.dart';

class TrainingService {
  static const String baseUrl = "https://vidyakosh.nic.in/api/get-training-calendar-data";

  static Future<List<Training>> fetchTrainings({
    required String year,
    String month = "",
    dynamic venue = "",
    int tabValue = 0,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "tabValue": tabValue,
          "year": year,
          "month": month,
          "venue": venue,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => Training.fromJson(item))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching trainings: $e");
    }
  }
}
