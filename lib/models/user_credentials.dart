import 'dart:convert';

CredentialModel credentialFromMap(String str) =>
    CredentialModel.fromMap(json.decode(str));

class CredentialModel {
  final String? biography;
  final DateTime? birthDate;
  List<String> hobbies;

  CredentialModel({
    this.biography,
    this.birthDate,
    this.hobbies = const [],
  });

  factory CredentialModel.fromMap(Map<String, dynamic> json) => CredentialModel(
        biography: json["biography"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        hobbies: json["hobbies"] == null
            ? []
            : List<String>.from(json["hobbies"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "biography": biography,
        "birthDate": birthDate == null ? "null" : birthDate!.toIso8601String(),
        "hobbies": List<dynamic>.from(hobbies.map((x) => x)),
      };

  @override
  String toString() => json.encode(toMap());

  bool hasChangesAtHobies(List<String> hobbies) {
    return this.hobbies != hobbies;
  }
}
