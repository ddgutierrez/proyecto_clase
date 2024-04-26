class UserSupport {
  final String id;
  final String name;
  final String email;
  final String password;

  UserSupport({required this.id, required this.name, required this.email, required this.password});

  factory UserSupport.fromJson(Map<String, dynamic> json) {
    return UserSupport(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
