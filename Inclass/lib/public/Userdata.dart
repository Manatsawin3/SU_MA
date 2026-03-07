class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;

  User(this.id, this.firstname, this.lastname, this.email);
  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      firstname = json['firstname'],
      lastname = json['lastname'],
      email = json['email'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
  };
}
