class Training {
  final int id;
  final String cityName;
  final String lastNominee;
  final String state;
  final String title;
  final String address;
  final String startDate;
  final String endDate;
  final int status;
  final int nominationRequired;
  final String flyer;
  final String venues;
  final String duration;
  final String designation;
  final String prerequisite;
  final String action;
  final int rowIndex;

  Training({
    required this.id,
    required this.cityName,
    required this.lastNominee,
    required this.state,
    required this.title,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.nominationRequired,
    required this.flyer,
    required this.venues,
    required this.duration,
    required this.designation,
    required this.prerequisite,
    required this.action,
    required this.rowIndex,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] ?? 0,
      cityName: json['cityname'] ?? '',
      lastNominee: json['lastnominne'] ?? '',
      state: json['state'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? 0,
      nominationRequired: json['nomination_required'] ?? 0,
      flyer: json['flyer'] ?? '',
      venues: json['venues'] ?? '',
      duration: json['duration'] ?? '',
      designation: json['designation'] ?? '',
      prerequisite: json['prerequisite'] ?? '',
      action: json['action'] ?? '',
      rowIndex: json['DT_RowIndex'] ?? 0,
    );
  }
}
