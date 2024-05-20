class Report {
  int? id;
  String report;
  int review;
  bool revised;
  int duration;
  String startTime;
  int supportUser;
  String clientName;

  Report({
    this.id,
    required this.report,
    required this.review,
    required this.revised,
    required this.duration,
    required this.startTime,
    required this.supportUser,
    required this.clientName,
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
      'clientName' : clientName
    };
  }

  // Create a Report object from a Map object
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id']
          as int?, // Ensure the ID is correctly parsed; it seems fine here.
      report: json['Report'] as String? ??
          '', // Use null-aware operators to default to an empty string if null.
      review: json['Review'] as int,
      revised: json['Revised'] as bool,
      duration: json['Duration'] as int,
      startTime: json['start_time'] as String? ??
          '', // Default to empty string if null.
      supportUser: json['Support_User'] as int,
      clientName: json['clientName'] as String? ??
      '', // Default to empty string if null.
    );
  }
}