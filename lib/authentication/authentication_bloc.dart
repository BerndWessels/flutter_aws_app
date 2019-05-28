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
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      bool isAuthenticated = await identityRepository.isAuthenticated();
      if (isAuthenticated) {
        yield AuthenticationAuthenticated(/*identityRepository?*/);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is Authenticate) {
      bool isAuthenticated = await identityRepository.authenticate(event.code);
      if (isAuthenticated) {
        yield AuthenticationAuthenticated(/*identityRepository?*/);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is SignOut) {
      bool isSignedOut = await identityRepository.signOut();
      if (isSignedOut) {
        yield AuthenticationUnauthenticated();
      }
    }
  }
}
