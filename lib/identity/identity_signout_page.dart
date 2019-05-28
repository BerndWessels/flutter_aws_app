import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/identity/identity.dart';
import 'package:flutter_aws_app/packages/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// The application's login page.
class IdentitySignOutPage extends StatefulWidget {
  @override
  _IdentitySignOutPageState createState() => new _IdentitySignOutPageState();
}

// The application's login page state.
class _IdentitySignOutPageState extends State<IdentitySignOutPage> {
  // Identity access.
  IdentityRepository _identityRepository;

  // Authentication Bloc.
  AuthenticationBloc _authenticationBloc;

  // Webview to present the sign in/up web page.
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // Webview subscriptions.
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _identityRepository = RepositoryProvider.of<IdentityRepository>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    // Close, just to be sure.
    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    // Add a listener to on state changed.
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed.
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url
          .startsWith(_identityRepository.cognitoUserPoolLogoutRedirectUrl)) {
        _authenticationBloc.dispatch(SignOut());
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String logoutUrl = _identityRepository.cognitoUserPoolLogoutUrl;
    return new WebviewScaffold(
      url: logoutUrl,
      hidden: true,
      appBar: new AppBar(
        title: new Text("Sign Out"),
      ),
      userAgent:
          // TODO change based on platform.
          "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
    );
  }
}
