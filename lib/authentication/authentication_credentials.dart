import 'dart:convert';

class AuthenticationCredentials {
  final String accessKeyId;
  final String secretKey;
  final String sessionToken;
  final DateTime expiryDateTime;

  AuthenticationCredentials({
    this.accessKeyId,
    this.expiryDateTime,
    this.secretKey,
    this.sessionToken,
  });

  factory AuthenticationCredentials.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json, reviver: (key, value) {
      return key == "expiryDateTime" ? DateTime.parse(value) : value;
    });
    return AuthenticationCredentials(
      accessKeyId: data["accessKeyId"],
      secretKey: data["secretKey"],
      sessionToken: data["sessionToken"],
      expiryDateTime: data["expiryDateTime"],
    );
  }

  String toJson() {
    return jsonEncode({
      "accessKeyId": accessKeyId,
      "secretKey": secretKey,
      "sessionToken": sessionToken,
      "expiryDateTime": expiryDateTime.toIso8601String()
    });
  }

  bool get hasExpired => DateTime.now().isAfter(expiryDateTime);
}
