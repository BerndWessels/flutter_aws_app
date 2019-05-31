import 'package:built_value/built_value.dart';

part 'home_states.g.dart';

abstract class HomeState {}

abstract class HomeInitial
    implements Built<HomeInitial, HomeInitialBuilder>, HomeState {
  HomeInitial._();

  factory HomeInitial([void Function(HomeInitialBuilder) updates]) =
      _$HomeInitial;
}

abstract class HomeSuccess
    implements Built<HomeSuccess, HomeSuccessBuilder>, HomeState {
  HomeSuccess._();

  factory HomeSuccess([void Function(HomeSuccessBuilder) updates]) =
      _$HomeSuccess;
}

abstract class HomeLoading
    implements Built<HomeLoading, HomeLoadingBuilder>, HomeState {
  HomeLoading._();

  factory HomeLoading([void Function(HomeLoadingBuilder) updates]) =
      _$HomeLoading;
}
