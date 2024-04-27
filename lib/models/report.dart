class Report {
  int? id;
  String report;
  int review;
  bool revised;
  int duration;
  String startTime;
  int supportUser;

  Report({
    this.id,
    required this.report,
    required this.review,
    required this.revised,
    required this.duration,
    required this.startTime,
    required this.supportUser,
  });

  // Convert a Report object into a Map object
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'Report': report,
      'Review': review,
      'Revised': revised,
      'Duration': duration,
      'start_time': startTime,
      'Support_User': supportUser,
    };
  }

  // Create a Report object from a Map object
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int?,
      report: json['Report'] as String,
      review: json['Review'] as int,
      revised: json['Revised'] as bool,
      duration: json['Duration'] as int,
      startTime: json['start_time'] as String,
      supportUser: json['Support_User'] as int,
    );
  }
}
