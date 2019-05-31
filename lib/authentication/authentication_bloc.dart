import 'package:bloc/bloc.dart';
import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/identity/identity.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IdentityRepository identityRepository;

  AuthenticationBloc({@required this.identityRepository})
      : assert(identityRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      bool isAuthenticated = await identityRepository.isAuthenticated();
      if (isAuthenticated) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    }
    if (event is Authenticate) {
      // If this fails (e.g. being offline) the code will be unusable anyways.
      // So no need to retry, but rather having to sign in again.
      bool isAuthenticated = await identityRepository.authenticate(event.code);
      if (isAuthenticated) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    }
    if (event is SignOut) {
      bool isSignedOut = await identityRepository.signOut();
      if (isSignedOut) {
        yield Unauthenticated();
      }
    }
  }
}
