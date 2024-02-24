/// User Data Type Definition
class User {
  User(
      {required this.id,
      required this.name,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.img,
      required this.profession,
      required this.bio,
      required this.blocked,
      required this.emailVerified});
  final int id;
  late String name;
  late String firstName;
  late String lastName;
  late String email;
  late String img;
  late String profession;
  late String bio;
  late bool blocked;
  late String emailVerified;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['full_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      img: json['profile_picture'],
      profession: json['profession'],
      bio: json['short_bio'],
      blocked: json['blocked'] == 0 ? false : true,
      emailVerified: json['verified_at'],
    );
  }
}
