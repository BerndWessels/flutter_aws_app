import 'dart:convert';

import 'package:flutter_aws_app/models/models.dart';
import 'package:flutter_aws_app/packages/sig_v4.dart';
import 'package:http/http.dart' as http;

class QueryProvider {
  final String endpoint;
  final String region;

  QueryProvider(this.endpoint, this.region);

  Future<dynamic> post(
    String accessKey,
    String secretKey,
    String sessionToken,
    String operationName,
    String query,
  ) async {
    final sigV4Client = new AwsSigV4Client(
      accessKey,
      secretKey,
      endpoint,
      serviceName: 'appsync',
      sessionToken: sessionToken,
      region: region,
    );

    final sigV4Request = new SigV4Request(
      sigV4Client,
      method: "POST",
      path: "/graphql",
      headers: new Map<String, String>.from({
        "Content-Type": "application/graphql; charset=utf-8",
      }),
      body: new Map<String, dynamic>.from({
        "operationName": operationName,
        "query": query,
      }),
    );

    http.Response response;
    try {
      response = await http.post(
        sigV4Request.url,
        headers: sigV4Request.headers,
        body: sigV4Request.body,
      );
    } catch (e) {
      print(e);
      return null;
    }
    var data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      print(e);
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
        print("$errorType, statusCode: ${response.statusCode}");
      }
      return null;
    }
    // TODO errors are per field, so is this to restrictive?
    if (data["errors"] != null) {
      print(data["errors"]);
      return null;
    }
    return data;
  }

  Future<Query> query(
    String accessKey,
    String secretKey,
    String sessionToken,
    String fragment,
  ) async {
    var data = await post(
      accessKey,
      secretKey,
      sessionToken,
      "operation",
      "query operation { $fragment }",
    );
    Query query;
    try {
      query =
          standardSerializers.deserializeWith(Query.serializer, data["data"]);
    } catch (e) {
      print(e);
      return null;
    }
    return query;
  }
}

//var x = standardSerializers.deserializeWith(PetList.serializer, data["data"]);
//final specifiedType = FullType(BuiltList, const [const FullType(Pet)]);
//var x = standardSerializers.deserialize(data["data"]["listPets"], specifiedType: specifiedType);

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

// {"data":{"listPets":null},"errors":[{"path":["listPets"],"data":null,"errorType":"ExecutionTimeout","errorInfo":null,"locations":[{"line":2,"column":9,"sourceName":null}],"message":"Execution timed out."}]}

// {"data":{"listPets":[{"id":"e26b33ed-c2b4-45e0-a344-aa8775a57861","price":11.0,"type":"fish"}]}}
