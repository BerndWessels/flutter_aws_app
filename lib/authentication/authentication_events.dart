import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class Authenticate extends AuthenticationEvent {
  final String code;

  Authenticate({@required this.code}) : super([code]);

  @override
  String toString() => 'Authenticate { code: $code }';
}

class SignOut extends AuthenticationEvent {
  @override
  String toString() => 'SignOut';
}
