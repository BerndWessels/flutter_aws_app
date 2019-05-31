import 'package:built_value/built_value.dart';

part 'authentication_states.g.dart';

abstract class AuthenticationState {}

abstract class Authenticated
    implements Built<Authenticated, AuthenticatedBuilder>, AuthenticationState {
  Authenticated._();

  factory Authenticated([void Function(AuthenticatedBuilder) updates]) =
      _$Authenticated;
}

abstract class Unauthenticated
    implements
        Built<Unauthenticated, UnauthenticatedBuilder>,
        AuthenticationState {
  Unauthenticated._();

  factory Unauthenticated([void Function(UnauthenticatedBuilder) updates]) =
      _$Unauthenticated;
}

abstract class Uninitialized
    implements Built<Uninitialized, UninitializedBuilder>, AuthenticationState {
  Uninitialized._();

  factory Uninitialized([void Function(UninitializedBuilder) updates]) =
      _$Uninitialized;
}
