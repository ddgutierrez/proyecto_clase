class Client {
  final String id;
  final String name;

  // Constructor for creating a new Client instance
  Client({required this.id, required this.name});

  // Factory constructor for creating a new Client instance from a map
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'].toString(),  // Ensure the 'id' is converted to a string if necessary
      name: json['name'],
    );
  }

  // Method to convert a Client instance into a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
