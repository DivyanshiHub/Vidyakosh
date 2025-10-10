import 'package:flutter/material.dart';
import '../models/e_learning.dart';

class ELearningCard extends StatelessWidget {
  final ELearningCourse course;

  const ELearningCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String trackName;
    print("TrackId from API: ${course.track_id}");
    switch (course.track_id) {
      case 1:
        trackName = "TDP";
        break;
      case 2:
        trackName = "MDP";
        break;
      default:
        trackName = "Unknown"; // fallback
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top image + chips
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  course.image,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Chip(
                  label: Text(
                    trackName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Chip(
                  label: Text(
                    course.level,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),

          // 🔹 Course details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 6),
                Text("Allocated Year: ${course.allocatedYear}",
                    style: const TextStyle(color: Colors.black87)),

                // ⭐ Ratings with stars
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      if (index < course.averageRating.floor()) {
                        return const Icon(Icons.star,
                            size: 18, color: Colors.amber);
                      } else if (index < course.averageRating) {
                        return const Icon(Icons.star_half,
                            size: 18, color: Colors.amber);
                      } else {
                        return const Icon(Icons.star_border,
                            size: 18, color: Colors.amber);
                      }
                    }),
                    const SizedBox(width: 6),
                    Text("(${course.averageRating})",
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),

                Text("${course.daysRemaining} Days Remaining",
                    style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // 🔹 Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: course.progress / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 6),
                Text("${course.progress}% Completed",
                    style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 10),

                // 🔹 Continue button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: navigate to details page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Continue",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
