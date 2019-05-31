// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_events.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Fetch extends Fetch {
  @override
  final String operationName;
  @override
  final String query;

  factory _$Fetch([void Function(FetchBuilder) updates]) =>
      (new FetchBuilder()..update(updates)).build();

  _$Fetch._({this.operationName, this.query}) : super._() {
    if (operationName == null) {
      throw new BuiltValueNullFieldError('Fetch', 'operationName');
    }
    if (query == null) {
      throw new BuiltValueNullFieldError('Fetch', 'query');
    }
  }

  @override
  Fetch rebuild(void Function(FetchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FetchBuilder toBuilder() => new FetchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Fetch &&
        operationName == other.operationName &&
        query == other.query;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, operationName.hashCode), query.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Fetch')
          ..add('operationName', operationName)
          ..add('query', query))
        .toString();
  }
}

class FetchBuilder implements Builder<Fetch, FetchBuilder> {
  _$Fetch _$v;

  String _operationName;
  String get operationName => _$this._operationName;
  set operationName(String operationName) =>
      _$this._operationName = operationName;

  String _query;
  String get query => _$this._query;
  set query(String query) => _$this._query = query;

  FetchBuilder();

  FetchBuilder get _$this {
    if (_$v != null) {
      _operationName = _$v.operationName;
      _query = _$v.query;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Fetch other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Fetch;
  }

  @override
  void update(void Function(FetchBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Fetch build() {
    final _$result =
        _$v ?? new _$Fetch._(operationName: operationName, query: query);
    replace(_$result);
    return _$result;
  }
}

class _$Initialize extends Initialize {
  factory _$Initialize([void Function(InitializeBuilder) updates]) =>
      (new InitializeBuilder()..update(updates)).build();

  _$Initialize._() : super._();

  @override
  Initialize rebuild(void Function(InitializeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InitializeBuilder toBuilder() => new InitializeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Initialize;
  }

  @override
  int get hashCode {
    return 33416838;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper('Initialize').toString();
  }
}

class InitializeBuilder implements Builder<Initialize, InitializeBuilder> {
  _$Initialize _$v;

  InitializeBuilder();

  @override
  void replace(Initialize other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Initialize;
  }

  @override
  void update(void Function(InitializeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Initialize build() {
    final _$result = _$v ?? new _$Initialize._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
