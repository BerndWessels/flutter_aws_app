import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pet.g.dart';

abstract class Pet implements Built<Pet, PetBuilder> {
  static Serializer<Pet> get serializer => _$petSerializer;

  Pet._();

  factory Pet([void Function(PetBuilder) updates]) = _$Pet;

  String get id;

  String get type;

  double get price;
}
