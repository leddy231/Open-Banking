class Contact {
  final String name;
  final String orgnr;
  final String reference;
  final String phonenr;
  final String email;
  final String address;
  final String postnr;
  final String city;
  final String country;
  String id;
  Contact(
      {this.name,
      this.orgnr,
      this.reference,
      this.phonenr,
      this.email,
      this.address,
      this.postnr,
      this.city,
      this.country,
      this.id});

  Contact.fromJSON(Map<String, dynamic> data, [this.id])
      : name    = data['name'],
      orgnr     = data['orgnr'],
      reference = data['reference'],
      phonenr   = data['phonenr'],
      email     = data['email'],
      address   = data['address'],
      postnr    = data['postnr'],
      city      = data['city'],
      country   = data['country'];

  Map<String, dynamic> toJSON() => {
        'name'      : name,
        'orgnr'     : orgnr,
        'reference' : reference,
        'phonenr'   : phonenr,
        'email'     : email,
        'address'   : address,
        'postnr'    : postnr,
        'city'      : city,
        'country'   : country,
        'id'        : id
      };
}
