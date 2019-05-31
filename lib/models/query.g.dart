// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Query> _$querySerializer = new _$QuerySerializer();

class _$QuerySerializer implements StructuredSerializer<Query> {
  @override
  final Iterable<Type> types = const [Query, _$Query];
  @override
  final String wireName = 'Query';

  @override
  Iterable serialize(Serializers serializers, Query object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.getPet != null) {
      result
        ..add('getPet')
        ..add(serializers.serialize(object.getPet,
            specifiedType: const FullType(Pet)));
    }
    if (object.listPets != null) {
      result
        ..add('listPets')
        ..add(serializers.serialize(object.listPets,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Pet)])));
    }

    return result;
  }

  @override
  Query deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QueryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'getPet':
          result.getPet.replace(serializers.deserialize(value,
              specifiedType: const FullType(Pet)) as Pet);
          break;
        case 'listPets':
          result.listPets.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Pet)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$Query extends Query {
  @override
  final Pet getPet;
  @override
  final BuiltList<Pet> listPets;

  factory _$Query([void Function(QueryBuilder) updates]) =>
      (new QueryBuilder()..update(updates)).build();

  _$Query._({this.getPet, this.listPets}) : super._();

  @override
  Query rebuild(void Function(QueryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryBuilder toBuilder() => new QueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Query &&
        getPet == other.getPet &&
        listPets == other.listPets;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, getPet.hashCode), listPets.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Query')
          ..add('getPet', getPet)
          ..add('listPets', listPets))
        .toString();
  }
}

class QueryBuilder implements Builder<Query, QueryBuilder> {
  _$Query _$v;

  PetBuilder _getPet;
  PetBuilder get getPet => _$this._getPet ??= new PetBuilder();
  set getPet(PetBuilder getPet) => _$this._getPet = getPet;

  ListBuilder<Pet> _listPets;
  ListBuilder<Pet> get listPets => _$this._listPets ??= new ListBuilder<Pet>();
  set listPets(ListBuilder<Pet> listPets) => _$this._listPets = listPets;

  QueryBuilder();

  QueryBuilder get _$this {
    if (_$v != null) {
      _getPet = _$v.getPet?.toBuilder();
      _listPets = _$v.listPets?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Query other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Query;
  }

  @override
  void update(void Function(QueryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Query build() {
    _$Query _$result;
    try {
      _$result = _$v ??
          new _$Query._(getPet: _getPet?.build(), listPets: _listPets?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'getPet';
        _getPet?.build();
        _$failedField = 'listPets';
        _listPets?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Query', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
