class CustomerProfileModel {
  final CustomerProfileData? data;

  CustomerProfileModel({this.data});

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      data: json["data"] != null
          ? CustomerProfileData.fromJson(json["data"] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data?.toJson(),
    };
  }
}

class CustomerProfileData {
  final CustomerProfile? customer;

  CustomerProfileData({this.customer});

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) {
    return CustomerProfileData(
      customer: json["customer"] != null
          ? CustomerProfile.fromJson(json["customer"] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer": customer?.toJson(),
    };
  }
}

class CustomerProfile {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  CustomerProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json["id"]?.toString(),
      firstName: json["firstName"]?.toString(),
      lastName: json["lastName"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
    };
  }
}
