import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/e_learning.dart';

class ELearningService {
  Future<List<ELearningCourse>> fetchCourses() async {
    // load local JSON for now
    final response = await rootBundle.loadString('mock_data/e_learning.json');
    final data = json.decode(response)['data'] as List;
    return data.map((json) => ELearningCourse.fromJson(json)).toList();
  }

// Later you can add:
// Future<List<ELearningCourse>> fetchCoursesFromApi() async { ... }
}
