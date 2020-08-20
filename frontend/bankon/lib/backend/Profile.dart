class Profile {
  final String id;
  final String email;
  final String name;
  final String fakturaaccount;
  final String address;
  final String skattesats;

  Profile({
    this.id,
    this.email,
    this.name,
    this.fakturaaccount,
    this.address,
    this.skattesats
  });

  Profile.fromJson(dynamic data)
      : id = data['id'],
        email = data['email'],
        name = data['name'],
        fakturaaccount = data['fakturaaccount'],
        address = data['address'],
        skattesats = data['skattesats'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'fakturaaccount': fakturaaccount,
    'address': address,
    'skattesats': skattesats
  };

  String toString() => toJson().toString();
}