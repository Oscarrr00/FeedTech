part of 'pair_feeders_bloc.dart';

@immutable
abstract class FeedersState {}

class FeedersInitial extends FeedersState {}

class LoadingUserFeedersState extends FeedersState {}

class FeedersLoadedState extends FeedersState {
  final List<Feeder> userFeeders;

  FeedersLoadedState({required this.userFeeders});
}

class UserHasNoFeedersState extends FeedersState {}

class DiscoveringFeedersState extends FeedersState {
  final List<BluetoothDiscoveryResult> feeders;
  DiscoveringFeedersState({required this.feeders});
}

class FinishedDiscoveringFeedersState extends FeedersState {
  final List<BluetoothDiscoveryResult> feeders;
  FinishedDiscoveringFeedersState({required this.feeders});
}

class BluetoothErrorFeederState extends FeedersState {}

class PairingFeederState extends FeedersState {}

class FeederNewFeederPaired extends FeedersState {}
