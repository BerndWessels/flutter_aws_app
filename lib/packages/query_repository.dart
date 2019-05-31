import 'package:flutter_aws_app/identity/identity.dart';
import 'package:flutter_aws_app/models/models.dart';
import 'package:flutter_aws_app/packages/query_provider.dart';
import 'package:flutter_aws_app/packages/repository.dart';
import 'package:meta/meta.dart';

class QueryRepository extends Repository {
  final IdentityRepository identityRepository;
  final String endpoint;
  final String region;
  final QueryProvider _queryProvider;

  QueryRepository({
    @required this.endpoint,
    @required this.region,
    @required this.identityRepository,
  }) : _queryProvider = QueryProvider(endpoint, region);

  Future<Query> query(String fragment, {int retryCount = -1}) async {
    Query response;
    int retry = 0;
    do {
      print("try #$retry");
      response = await _query(fragment);
    } while (response == null && retry++ < retryCount);
    return response;
  }

  Future<Query> _query(String fragment) async {
    var credentials = await identityRepository.credentials;
    if (credentials == null) {
      return null;
    }
    var response = await _queryProvider.query(
      credentials.accessKeyId,
      credentials.secretKey,
      credentials.sessionToken,
      fragment,
    );
    return response;
  }
}
