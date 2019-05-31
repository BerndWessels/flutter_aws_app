import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/identity/identity.dart';
import 'package:flutter_aws_app/packages/query_repository.dart';
import 'package:flutter_aws_app/packages/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';

import 'home/home.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

// The main entry point of this application.
void main() async {
  // Bloc logging.
  BlocSupervisor().delegate = SimpleBlocDelegate();
  // AWS Cognito.
  IdentityRepository identityRepository = IdentityRepository(
    region: "us-east-1",
    userPoolDomainPrefix: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    userPoolId: "us-east-1_xxxxxxxxx",
    userPoolAppClientId: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
    identityPoolId: "us-east-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    cognitoIdentityPoolUrl: "https://cognito-identity.us-east-1.amazonaws.com",
    cognitoUserPoolLoginRedirectUrl: "https://my.app",
    cognitoUserPoolLogoutRedirectUrl: "https://my.app",
    cognitoUserPoolLoginScopes: "phone email openid profile",
  );
  // AWS AppSync.
  QueryRepository queryRepository = QueryRepository(
    endpoint:
        "https://xxxxxxxxxxxxxxxxxxxxxxxxxx.appsync-api.us-east-1.amazonaws.com",
    region: "us-east-1",
    identityRepository: identityRepository,
  );
  // Run the application page.
  runApp(AppPage(identityRepository, queryRepository));
}

// The application's main page.
class AppPage extends StatefulWidget {
  final IdentityRepository identityRepository;
  final QueryRepository queryRepository;

  AppPage(this.identityRepository, this.queryRepository);

  @override
  _AppPageState createState() => _AppPageState();
}

// The application's main page state.
class _AppPageState extends State<AppPage> {
  AuthenticationBloc _authenticationBloc;

  // A stream of deep links.
  StreamSubscription _linksStreamSubscription;

  // Initialize the platform.
  _initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      // ...
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
      // ...
    }
    // Attach a listener to the stream.
    // Don't forget to call _sub.cancel() in dispose().
    _linksStreamSubscription = getLinksStream().listen((String link) {
      // Parse the link and warn the user, if it is not correct
      // ...
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      // ...
    });
  }

  // Dispose the platform.
  _disposePlatform() {
    _linksStreamSubscription.cancel();
  }

  // Initialize the page.
  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _authenticationBloc =
        AuthenticationBloc(identityRepository: widget.identityRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  // Dispose the page.
  @override
  void dispose() {
    _authenticationBloc.dispose();
    _disposePlatform();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProviderTree(
      repositoryProviders: [
        RepositoryProvider<IdentityRepository>(
          repository: widget.identityRepository,
        ),
        RepositoryProvider<QueryRepository>(
          repository: widget.queryRepository,
        )
      ],
      child: BlocProviderTree(
        blocProviders: [
          BlocProvider<AuthenticationBloc>(bloc: _authenticationBloc),
        ],
        child: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder:
              (BuildContext context, AuthenticationState authenticationState) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              onGenerateRoute: (RouteSettings routeSettings) {
                switch (routeSettings.name) {
                  case '/':
                    return MaterialPageRoute(
                        builder: (context) => HomePage(
                              title: "Bernd",
                            ));
                  case '/identity/signin':
                    return MaterialPageRoute(
                        builder: (context) => IdentitySignInPage());
                  case '/identity/signout':
                    return MaterialPageRoute(
                        builder: (context) => IdentitySignOutPage());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
