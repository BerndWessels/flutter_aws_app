import 'package:built_value/built_value.dart';

part 'home_events.g.dart';

abstract class HomeEvent {}

abstract class Fetch implements Built<Fetch, FetchBuilder>, HomeEvent {
  Fetch._();

  factory Fetch([void Function(FetchBuilder) updates]) = _$Fetch;

  String get operationName;

  String get query;
}

abstract class Initialize
    implements Built<Initialize, InitializeBuilder>, HomeEvent {
  Initialize._();

  factory Initialize([void Function(InitializeBuilder) updates]) = _$Initialize;
}
