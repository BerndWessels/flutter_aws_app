import 'package:flutter/material.dart';
import 'package:flutter_aws_app/authentication/authentication.dart';
import 'package:flutter_aws_app/home/home.dart';
import 'package:flutter_aws_app/packages/query_repository.dart';
import 'package:flutter_aws_app/packages/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QueryRepository _queryRepository;
  AuthenticationBloc _authenticationBloc;
  HomeBloc _homeBloc;
  int _counter = 0;

  @override
  void initState() {
    _queryRepository = RepositoryProvider.of<QueryRepository>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _homeBloc = HomeBloc(queryRepository: _queryRepository);
    _homeBloc.dispatch(Initialize());
//    _homeBloc.dispatch(Fetch(
//      (b) => b
//        ..operationName = "listPets"
//        ..query = """
//      query listPets {
//        listPets {
//          id
//          price
//          type
//        }
//      }
//    """,
//    ));
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void _incrementCounter() async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState authenticationState) {
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            actions: <Widget>[
              authenticationState is Authenticated
                  ? IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.pushNamed(context, "/identity/signout");
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.person_outline),
                      onPressed: () {
                        Navigator.pushNamed(context, "/identity/signin");
                      },
                    )
            ],
          ),
          body: BlocBuilder<HomeEvent, HomeState>(
              bloc: _homeBloc,
              builder: (BuildContext context, HomeState queryState) {
                return ModalProgressHUD(
                    inAsyncCall: queryState is HomeLoading,
                    dismissible: false,
                    opacity: .8,
                    color: Colors.white,
                    child: Center(
                      // Center is a layout widget. It takes a single child and positions it
                      // in the middle of the parent.
                      child: Column(
                        // Column is also layout widget. It takes a list of children and
                        // arranges them vertically. By default, it sizes itself to fit its
                        // children horizontally, and tries to be as tall as its parent.
                        //
                        // Invoke "debug painting" (press "p" in the console, choose the
                        // "Toggle Debug Paint" action from the Flutter Inspector in Android
                        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                        // to see the wireframe for each widget.
                        //
                        // Column has various properties to control how it sizes itself and
                        // how it positions its children. Here we use mainAxisAlignment to
                        // center the children vertically; the main axis here is the vertical
                        // axis because Columns are vertical (the cross axis would be
                        // horizontal).
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'You have pushed the button this many times: !!!',
                          ),
                          Text(
                            '$_counter',
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ],
                      ),
                    ));
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
