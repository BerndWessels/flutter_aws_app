import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/packages/sig_v4.dart';
import 'package:http/http.dart' as http;

class GraphQLApi {
  final String endpoint;
  final String region;

  GraphQLApi(this.endpoint, this.region);

  Future<dynamic> post(AuthenticationCredentials credentials,
      String operationName, String query) async {
    final awsSigV4Client = new AwsSigV4Client(
      credentials.accessKeyId,
      credentials.secretKey,
      endpoint,
      serviceName: 'appsync',
      sessionToken: credentials.sessionToken,
      region: region,
    );

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/graphql',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/graphql; charset=utf-8'}),
        body: new Map<String, dynamic>.from(
            {'operationName': operationName, 'query': query}));

    http.Response response;
    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    print(response.body);
    return response.body;
  }
}

//var timeout = {
//  "data": {"listPets": null},
//  "errors": [
//    {
//      "path": ["listPets"],
//      "data": null,
//      "errorType": "ExecutionTimeout",
//      "errorInfo": null,
//      "locations": [
//        {"line": 2, "column": 9, "sourceName": null}
//      ],
//      "message": "Execution timed out."
//    }
//  ]
//};
