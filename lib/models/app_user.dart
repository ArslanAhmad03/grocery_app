class AppUser {
  final String name;
  final String image;

  AppUser({required this.name, required this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    name: json['name'],
    image: json['image'],
  );
}
