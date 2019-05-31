import 'dart:convert';

import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/packages/repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class IdentityRepository extends Repository {
  final String region;
  final String userPoolDomainPrefix;
  final String userPoolId;
  final String userPoolAppClientId;
  final String identityPoolId;
  final String cognitoIdentityPoolUrl;
  final String cognitoUserPoolLoginRedirectUrl;
  final String cognitoUserPoolLogoutRedirectUrl;
  final String cognitoUserPoolLoginScopes;

  IdentityRepository({
    @required this.region,
    @required this.userPoolDomainPrefix,
    @required this.userPoolId,
    @required this.userPoolAppClientId,
    @required this.identityPoolId,
    @required this.cognitoIdentityPoolUrl,
    @required this.cognitoUserPoolLoginRedirectUrl,
    @required this.cognitoUserPoolLogoutRedirectUrl,
    @required this.cognitoUserPoolLoginScopes,
  });

  String get cognitoUserPoolLoginUrl =>
      "https://$userPoolDomainPrefix.auth.$region.amazoncognito.com/login?redirect_uri=${Uri.encodeFull(cognitoUserPoolLoginRedirectUrl)}&response_type=code&client_id=$userPoolAppClientId&identity_provider=COGNITO&scopes=${Uri.encodeFull(cognitoUserPoolLoginScopes)}";

  String get cognitoUserPoolLogoutUrl =>
      "https://$userPoolDomainPrefix.auth.$region.amazoncognito.com/logout?logout_uri=${Uri.encodeFull(cognitoUserPoolLogoutRedirectUrl)}&client_id=$userPoolAppClientId";

  String get cognitoUserPoolTokenUrl =>
      "https://$userPoolDomainPrefix.auth.$region.amazoncognito.com/oauth2/token";

  Future<bool> isAuthenticated() async {
    // called on AppStarted
    _authenticationTokens = await _getStoredTokens();
    return _authenticationTokens != null;
  }

  Future<bool> authenticate(String code) async {
    _authenticationTokens = await _exchangeGrantForTokens(code);
    if (_authenticationTokens == null) {
      return false;
    }
    return await _storeTokens(_authenticationTokens);
  }

  Future<bool> signOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "AuthenticationTokens");
    _authenticationTokens = null;
    await storage.delete(key: "AuthenticationIdentityId");
    _authenticationIdentityId = null;
    await storage.delete(key: "AuthenticationCredentials");
    _authenticationCredentials = null;
    return true;
  }

  Future<AuthenticationTokens> get tokens async {
    // Do we have an authenticated user pool identity already?
    if (_authenticationTokens == null) {
      // Try to get the last user.
      _authenticationTokens = await _getStoredTokens();
    }
    // Are the users tokens valid and not expired?
    if (_authenticationTokens != null && _authenticationTokens.hasExpired) {
      // Refresh the tokens and store them.
      _authenticationTokens =
          await _refreshTokens(_authenticationTokens.refreshToken);
      await _storeTokens(_authenticationTokens);
    }
    // If there hasn't been a last user then we return null,
    // otherwise we return the refreshed tokens.
    return _authenticationTokens;
  }

  Future<AuthenticationCredentials> get credentials async {
    // Do we have credentials already?
    if (_authenticationCredentials == null) {
      // Try to get the last credentials.
      _authenticationCredentials = await _getStoredCredentials();
    }
    // Are the credentials valid and not expired?
    if (_authenticationCredentials == null ||
        _authenticationCredentials.hasExpired) {
      // Do we have an identity pool identity already?
      if (_authenticationIdentityId == null) {
        // Try to get the last identity.
        _authenticationIdentityId = await _getStoredIdentityId();
        // Do we have an identity?
        if (_authenticationIdentityId == null) {
          // Get a new identity for the user.
          _authenticationIdentityId = await _getNewIdentity();
          // Store it.
          _storeIdentityId(_authenticationIdentityId);
        }
      }
      // Get valid user pool tokens.
      _authenticationTokens = await tokens;
      // Get new credentials for the user.
      _authenticationCredentials = await _getNewCredentials(
          _authenticationIdentityId, _authenticationTokens);
      if (_authenticationCredentials != null) {
        await _storeCredentials(_authenticationCredentials);
      }
    }
    return _authenticationCredentials;
  }

  // --------------------------------------------------------------------------
  // internals
  // --------------------------------------------------------------------------

  AuthenticationTokens _authenticationTokens;
  AuthenticationCredentials _authenticationCredentials;
  String _authenticationIdentityId;

  Future<String> _getStoredIdentityId() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: "AuthenticationIdentityId");
  }

  Future<bool> _storeIdentityId(String identityId) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "AuthenticationIdentityId", value: identityId);
    return true;
  }

  Future<AuthenticationTokens> _getStoredTokens() async {
    final storage = new FlutterSecureStorage();
    String tokensJson = await storage.read(key: "AuthenticationTokens");
    if (tokensJson == null) {
      return null;
    }
    return AuthenticationTokens.fromJson(tokensJson);
  }

  Future<bool> _storeTokens(AuthenticationTokens authenticationTokens) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: "AuthenticationTokens", value: authenticationTokens.toJson());
    return true;
  }

  Future<AuthenticationCredentials> _getStoredCredentials() async {
    final storage = new FlutterSecureStorage();
    String credentialsJson =
        await storage.read(key: "AuthenticationCredentials");
    if (credentialsJson == null) {
      return null;
    }
    return AuthenticationCredentials.fromJson(credentialsJson);
  }

  Future<bool> _storeCredentials(
      AuthenticationCredentials authenticationCredentials) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: "AuthenticationCredentials",
        value: authenticationCredentials.toJson());
    return true;
  }

  Future<AuthenticationTokens> _exchangeGrantForTokens(String code) async {
    Map<String, String> body = {
      "grant_type": "authorization_code",
      "code": code,
      "client_id": userPoolAppClientId,
      "redirect_uri": cognitoUserPoolLoginRedirectUrl,
    };
    http.Response response;
    try {
      response = await http.Client()
          .post(
            cognitoUserPoolTokenUrl,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      print("$cognitoUserPoolTokenUrl : $e");
      return null;
    }

    var data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      print("$cognitoUserPoolTokenUrl : $e");
      return null;
    }
    if (response.statusCode < 200 || response.statusCode > 299) {
      String errorType = "UnknownError";
      for (String header in response.headers.keys) {
        if (header.toLowerCase() == "x-amzn-errortype") {
          errorType = response.headers[header].split(':')[0];
          break;
        }
      }
      if (data == null) {
        print(
            "$cognitoUserPoolTokenUrl : $errorType, statusCode: ${response.statusCode}");
      }
      return null;
    }

    var tokens = AuthenticationTokens(
      accessToken: data["access_token"],
      expiryDateTime:
          DateTime.now().add(new Duration(seconds: data["expires_in"])),
      idToken: data["id_token"],
      refreshToken: data["refresh_token"],
    );
    return tokens;
  }

  Future<AuthenticationTokens> _refreshTokens(String refreshToken) async {
    Map<String, String> body = {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
      "client_id": userPoolAppClientId,
    };
    http.Response response;
    try {
      response = await http.Client()
          .post(
            cognitoUserPoolTokenUrl,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      print("$cognitoUserPoolTokenUrl : $e");
      return null;
    }

    var data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      print("$cognitoUserPoolTokenUrl : $e");
      return null;
    }
    if (response.statusCode < 200 || response.statusCode > 299) {
      String errorType = "UnknownError";
      for (String header in response.headers.keys) {
        if (header.toLowerCase() == "x-amzn-errortype") {
          errorType = response.headers[header].split(':')[0];
          break;
        }
      }
      if (data == null) {
        print(
            "$cognitoUserPoolTokenUrl : $errorType, statusCode: ${response.statusCode}");
      }
      return null;
    }

    var tokens = AuthenticationTokens(
      accessToken: data["access_token"],
      expiryDateTime:
          DateTime.now().add(new Duration(seconds: data["expires_in"])),
      idToken: data["id_token"],
      refreshToken: refreshToken,
    );
    return tokens;
  }

  Future<String> _getNewIdentity() async {
    http.Response response;
    try {
      response = await http.Client()
          .post(
            cognitoIdentityPoolUrl,
            headers: {
              "Content-Type": "application/x-amz-json-1.1",
              "X-Amz-Target": "AWSCognitoIdentityService.GetId",
            },
            body: jsonEncode({"IdentityPoolId": identityPoolId}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      print("$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetId : $e");
      return null;
    }

    var data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      print("$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetId : $e");
      return null;
    }
    if (response.statusCode < 200 || response.statusCode > 299) {
      String errorType = "UnknownError";
      for (String header in response.headers.keys) {
        if (header.toLowerCase() == "x-amzn-errortype") {
          errorType = response.headers[header].split(':')[0];
          break;
        }
      }
      if (data == null) {
        print(
            "$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetId : $errorType, statusCode: ${response.statusCode}");
      }
      return null;
    }
    return data["IdentityId"];
  }

  Future<AuthenticationCredentials> _getNewCredentials(
      String authenticationIdentityId,
      AuthenticationTokens authenticationTokens) async {
    http.Response response;
    try {
      response = await http.Client()
          .post(
            cognitoIdentityPoolUrl,
            headers: {
              "Content-Type": "application/x-amz-json-1.1",
              "X-Amz-Target":
                  "AWSCognitoIdentityService.GetCredentialsForIdentity",
            },
            body: jsonEncode({
              "IdentityId": authenticationIdentityId,
              "Logins": {
                "cognito-idp.$region.amazonaws.com/$userPoolId":
                    authenticationTokens.idToken,
              }
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      print(
          "$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetCredentialsForIdentity : $e");
      return null;
    }

    var data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      print(
          "$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetCredentialsForIdentity : $e");
      return null;
    }
    if (response.statusCode < 200 || response.statusCode > 299) {
      String errorType = "UnknownError";
      for (String header in response.headers.keys) {
        if (header.toLowerCase() == "x-amzn-errortype") {
          errorType = response.headers[header].split(':')[0];
          break;
        }
      }
      if (data == null) {
        print(
            "$cognitoIdentityPoolUrl : AWSCognitoIdentityService.GetCredentialsForIdentity : $errorType, statusCode: ${response.statusCode}");
      }
      return null;
    }
    double expiration = data["Credentials"]["Expiration"];
    var credentials = AuthenticationCredentials(
      accessKeyId: data["Credentials"]["AccessKeyId"],
      secretKey: data["Credentials"]["SecretKey"],
      sessionToken: data["Credentials"]["SessionToken"],
      expiryDateTime:
          DateTime.fromMillisecondsSinceEpoch(expiration.toInt() * 1000),
    );
    return credentials;
  }
}
