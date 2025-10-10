class ELearningCourse {
  final String id;
  final int track_id;
  final String level;
  final String allocatedYear;
  final String title;
  final double averageRating;
  final String daysRemaining;
  final String traineesCount;
  final double progress;
  final String image;
  final String detailsUrl;

  ELearningCourse({
    required this.id,
    required this.track_id,
    required this.level,
    required this.allocatedYear,
    required this.title,
    required this.averageRating,
    required this.daysRemaining,
    required this.traineesCount,
    required this.progress,
    required this.image,
    required this.detailsUrl,
  });

  factory ELearningCourse.fromJson(Map<String, dynamic> json) {
    print("Raw course JSON: $json");
    return ELearningCourse(
      id: json['id']?.toString() ?? '',
      track_id: int.tryParse(json['track_id'].toString()) ?? 0,
      level: json['level'] as String,
      allocatedYear: json['allocated_year'] as String,
      title: json['title'] as String,
      averageRating: (json['average_rating'] is String)
          ? double.tryParse(json['average_rating']) ?? 0.0
          : (json['average_rating'] as num).toDouble(),
      daysRemaining: json['days_remaining']?.toString() ?? '',
      traineesCount: json['trainees_count']?.toString() ?? '',
      progress: (json['progress'] is int)
        ? (json['progress'] as int).toDouble()
        : (json['progress'] as num).toDouble(),
      image: json['image'] as String,
      detailsUrl: json['details_url'] as String,
    );
  }
  // String get trackName {
  //   switch (track_id) {
  //     case 1:
  //       return "TDP";
  //     case 2:
  //       return "MDP";
  //     default:
  //       return "Unknown";
  //   }
  // }
}
