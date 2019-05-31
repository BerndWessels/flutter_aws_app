import 'package:bloc/bloc.dart';
import 'package:flutter_aws_app/home/home.dart';
import 'package:flutter_aws_app/packages/query_repository.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final QueryRepository queryRepository;

  HomeBloc({@required this.queryRepository}) : assert(queryRepository != null);

  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is Initialize) {
      yield HomeLoading();
      var response = await queryRepository.query(
        """
        listPets {
          id
          price
          type
        }
        """,
      ); // , cache , retry , pollingInterval
      var response2 = response.rebuild((b) => b..listPets[0] = b.listPets[0].rebuild((b) => b..price += 10));
      print(response);
      print(response2); // now this should be the new value in the cache ?!?!?!?!
      yield HomeSuccess();
    }
  }
}
