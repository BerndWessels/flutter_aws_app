import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'models.dart';

part 'query.g.dart';

abstract class Query implements Built<Query, QueryBuilder> {
  static Serializer<Query> get serializer => _$querySerializer;

  Query._();

  factory Query([void Function(QueryBuilder) updates]) = _$Query;

  @nullable
  Pet get getPet;

  @nullable
  BuiltList<Pet> get listPets;
}
