part of 'pair_feeders_bloc.dart';

@immutable
abstract class FeedersEvent {}

class LoadUserFeedersEvent extends FeedersEvent {}

class PairNewFeederEvent extends FeedersEvent {
  final BluetoothDevice device;

  PairNewFeederEvent({required this.device});
}

class DiscoverFeedersEvent extends FeedersEvent {}
