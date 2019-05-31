import 'package:built_value/built_value.dart';

part 'authentication_events.g.dart';

abstract class AuthenticationEvent {}

abstract class AppStarted
    implements Built<AppStarted, AppStartedBuilder>, AuthenticationEvent {
  AppStarted._();

  factory AppStarted([void Function(AppStartedBuilder) updates]) = _$AppStarted;
}

abstract class Authenticate
    implements Built<Authenticate, AuthenticateBuilder>, AuthenticationEvent {
  Authenticate._();

  factory Authenticate([void Function(AuthenticateBuilder) updates]) =
      _$Authenticate;

  String get code;
}

abstract class SignOut
    implements Built<SignOut, SignOutBuilder>, AuthenticationEvent {
  SignOut._();

  factory SignOut([void Function(SignOutBuilder) updates]) = _$SignOut;
}
