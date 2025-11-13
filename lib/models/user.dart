class User {
  String userId;
  String name;
  String fatherName;
  String city;
  String country;
  int age;

  User({
    required this.userId,
    required this.name,
    required this.fatherName,
    required this.city,
    required this.country,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['user_id'],
    name: json['name'],
    fatherName: json['father_name'],
    city: json['city'],
    country: json['country'],
    age: json['age'],
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'father_name': fatherName,
    'city': city,
    'country': country,
    'age': age,
  };
}
