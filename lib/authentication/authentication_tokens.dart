import 'dart:convert';

class AuthenticationTokens {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final DateTime expiryDateTime;

  AuthenticationTokens({
    this.accessToken,
    this.expiryDateTime,
    this.idToken,
    this.refreshToken,
  });

  factory AuthenticationTokens.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json, reviver: (key, value) {
      return key == "expiryDateTime" ? DateTime.parse(value) : value;
    });
    return AuthenticationTokens(
      accessToken: data["accessToken"],
      refreshToken: data["refreshToken"],
      idToken: data["idToken"],
      expiryDateTime: data["expiryDateTime"],
    );
  }

  String toJson() {
    return jsonEncode({
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "idToken": idToken,
      "expiryDateTime": expiryDateTime.toIso8601String()
    });
  }

  bool get hasExpired => DateTime.now().isAfter(expiryDateTime);
}
