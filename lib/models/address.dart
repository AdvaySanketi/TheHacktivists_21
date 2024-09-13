class Address {
  String? id;
  String? user_id;
  String address;
  String city;
  String state;
  String pincode;
  String phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Address(
      {required this.address,
      required this.city,
      required this.state,
      required this.pincode,
      required this.phone,
      this.id,
      this.user_id,
      this.createdAt,
      this.updatedAt,
      this.v});
}
