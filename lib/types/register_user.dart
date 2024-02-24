/// Register User Data Type Definition
class RegisterUser {
  RegisterUser({
    required this.id,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.profession,
    required this.bio,
  });
  late int id;
  late String email;
  late String password;
  late String passwordConfirmation;
  late String firstName;
  late String lastName;
  late String dateOfBirth;
  late String profession;
  late String bio;
}
