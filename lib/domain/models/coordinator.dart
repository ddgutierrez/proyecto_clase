class Coordinator {
  final String id;
  final String email;
  final String password;

  Coordinator(
      {required this.id,
      required this.email,
      required this.password});

  factory Coordinator.fromJson(Map<String, dynamic> json) {
    return Coordinator(
      id: json['id'].toString(),
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
  Coordinator copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) {
    return Coordinator(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
