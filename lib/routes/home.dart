import 'package:flutter/material.dart';
import 'package:vidyakosh/routes/e_learning.dart';
import 'package:vidyakosh/routes/training_calender.dart';
import 'package:vidyakosh/routes/trainings.dart';
import '../page/homeGradient.dart';
import 'course.dart';
import 'trainingHome.dart';
import 'webinar.dart';
import 'igot.dart';
import '../services/logout.dart';  // ✅ Import the service

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages for each tab
  static final List<Widget> _pages = <Widget>[
    const HomeContent(),
    ELearningPage(),
    TrainPage(),
    TrainingCalendarPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "E-Learning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Trainings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Training Calendar",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: homeGradient(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + Profile Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: "Hi 👋\n",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          TextSpan(
                              text: "Welcome Back",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                        ],
                      ),
                    ),
                    // ✅ Profile icon with popup menu
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          LogoutService.logout(context);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text("Logout"),
                          ),
                        ];
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.pinkAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Find Your Course...",
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 25),

                // Section title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Choose Your Course",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("More >>",
                        style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                  ],
                ),
                const SizedBox(height: 20),

                // Grid of courses
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCourseCard(
                      context,
                      "Completed Courses",
                      Colors.redAccent,
                      CoursePage(),
                      Icons.web,
                      count : 7,
                    ),
                    _buildCourseCard(
                      context,
                      "Trainings Attended",
                      Colors.blueAccent,
                      const TrainingsPage(),
                      Icons.design_services,
                      count : 3,
                    ),
                    _buildCourseCard(
                      context,
                      "IGot Completed courses",
                      Colors.green,
                      const IgotPage(),
                      Icons.android,
                      count : 1,
                    ),
                    _buildCourseCard(
                      context,
                      "Webinar Attended",
                      Colors.amber,
                      const WebinarPage(),
                      Icons.campaign,
                      count : 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, String title,  Color color, Widget page, IconData icon, {int count = 0}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(2),
        child: Stack(
          children: [
            // Title at top
            Positioned(
              top: 20,
              left: 15,
              right: 0,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            // Icon at bottom-left
            Positioned(
              bottom: 10,
              left: 15,
              child: Icon(icon, size: 45, color: color),
            ),

            // Count at bottom-right
            Positioned(
              bottom: 10,
              right: 15,
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
