import 'package:flutter/material.dart';
import 'package:vidyakosh/page/homeGradient.dart';
import '../services/e_learning_services.dart';
import '../models/e_learning.dart';
import '../widgets/e_learning_card.dart';
import '../page/appBarGradient.dart';

class ELearningPage extends StatefulWidget {
  const ELearningPage({Key? key}) : super(key: key);

  @override
  State<ELearningPage> createState() => _ELearningPageState();
}

class _ELearningPageState extends State<ELearningPage> with SingleTickerProviderStateMixin {
  final ELearningService _service = ELearningService();
  late Future<List<ELearningCourse>> _futureCourses;
  late TabController _tabController;

  List<ELearningCourse> _allCourses = [];
  List<ELearningCourse> _tdpCourses = [];
  List<ELearningCourse> _mdpCourses = [];

  @override
  void initState() {
    super.initState();
    _futureCourses = _service.fetchCourses();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _categorizeCourses(List<ELearningCourse> courses) {
    _allCourses = courses;
    _tdpCourses = courses.where((c) => c.track_id == 1).toList();
    _mdpCourses = courses.where((c) => c.track_id == 2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("E-Learning Courses"),
      body: homeGradient(
        child: FutureBuilder<List<ELearningCourse>>(
          future: _futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No courses available"));
            }

            // Categorize courses
            _categorizeCourses(snapshot.data!);

            return Column(
              children: [
                // 🔹 TabBar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.red.shade200,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text('All',
                          style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('TDP',
                          style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('MDP',style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 🔹 TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // All Courses
                      ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _allCourses.length,
                        itemBuilder: (context, index) {
                          return ELearningCard(course: _allCourses[index]);
                        },
                      ),

                      // TDP Courses
                      ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _tdpCourses.length,
                        itemBuilder: (context, index) {
                          return ELearningCard(course: _tdpCourses[index]);
                        },
                      ),

                      // MDP Courses
                      ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _mdpCourses.length,
                        itemBuilder: (context, index) {
                          return ELearningCard(course: _mdpCourses[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
