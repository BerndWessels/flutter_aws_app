import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_aws_app/models/models.dart';

part 'serializers.g.dart';

@SerializersFor([
  Query,
  Pet,
])
final Serializers serializers = _$serializers;

//final Serializers serializers = (_$serializers.toBuilder()
//      ..addBuilderFactory(
//          const FullType(BuiltList, const [const FullType(Pet)]),
//          () => new ListBuilder<Pet>()))
//    .build();

final standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
