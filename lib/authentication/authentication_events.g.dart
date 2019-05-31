// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_events.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppStarted extends AppStarted {
  factory _$AppStarted([void Function(AppStartedBuilder) updates]) =>
      (new AppStartedBuilder()..update(updates)).build();

  _$AppStarted._() : super._();

  @override
  AppStarted rebuild(void Function(AppStartedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStartedBuilder toBuilder() => new AppStartedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppStarted;
  }

  @override
  int get hashCode {
    return 805240986;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper('AppStarted').toString();
  }
}

class AppStartedBuilder implements Builder<AppStarted, AppStartedBuilder> {
  _$AppStarted _$v;

  AppStartedBuilder();

  @override
  void replace(AppStarted other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppStarted;
  }

  @override
  void update(void Function(AppStartedBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppStarted build() {
    final _$result = _$v ?? new _$AppStarted._();
    replace(_$result);
    return _$result;
  }
}

class _$Authenticate extends Authenticate {
  @override
  final String code;

  factory _$Authenticate([void Function(AuthenticateBuilder) updates]) =>
      (new AuthenticateBuilder()..update(updates)).build();

  _$Authenticate._({this.code}) : super._() {
    if (code == null) {
      throw new BuiltValueNullFieldError('Authenticate', 'code');
    }
  }

  @override
  Authenticate rebuild(void Function(AuthenticateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticateBuilder toBuilder() => new AuthenticateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Authenticate && code == other.code;
  }

  @override
  int get hashCode {
    return $jf($jc(0, code.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Authenticate')..add('code', code))
        .toString();
  }
}

class AuthenticateBuilder
    implements Builder<Authenticate, AuthenticateBuilder> {
  _$Authenticate _$v;

  String _code;
  String get code => _$this._code;
  set code(String code) => _$this._code = code;

  AuthenticateBuilder();

  AuthenticateBuilder get _$this {
    if (_$v != null) {
      _code = _$v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Authenticate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Authenticate;
  }

  @override
  void update(void Function(AuthenticateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Authenticate build() {
    final _$result = _$v ?? new _$Authenticate._(code: code);
    replace(_$result);
    return _$result;
  }
}

class _$SignOut extends SignOut {
  factory _$SignOut([void Function(SignOutBuilder) updates]) =>
      (new SignOutBuilder()..update(updates)).build();

  _$SignOut._() : super._();

  @override
  SignOut rebuild(void Function(SignOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignOutBuilder toBuilder() => new SignOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignOut;
  }

  @override
  int get hashCode {
    return 957153408;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper('SignOut').toString();
  }
}

class SignOutBuilder implements Builder<SignOut, SignOutBuilder> {
  _$SignOut _$v;

  SignOutBuilder();

  @override
  void replace(SignOut other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SignOut;
  }

  @override
  void update(void Function(SignOutBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SignOut build() {
    final _$result = _$v ?? new _$SignOut._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
