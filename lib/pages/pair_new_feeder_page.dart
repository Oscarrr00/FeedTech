import 'package:feedtech/blocs/feeders/bloc/pair_feeders_bloc.dart';
import 'package:feedtech/items/bluetooth_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PairNewFeederPage extends StatelessWidget {
  const PairNewFeederPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PairFeedersBloc>().add(DiscoverFeedersEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text("Finding Feeders"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              context.read<PairFeedersBloc>().add(LoadUserFeedersEvent());
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
              onPressed: () {
                context.read<PairFeedersBloc>().add(DiscoverFeedersEvent());
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocConsumer<PairFeedersBloc, FeedersState>(
        listener: (context, state) {
          if (state is FeederNewFeederPaired) {
            context.read<PairFeedersBloc>().add(LoadUserFeedersEvent());
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is UserHasNoFeedersState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DiscoveringFeedersState) {
            if (state.feeders.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return _getBluetoothDevicesList(state.feeders);
          } else if (state is FinishedDiscoveringFeedersState) {
            return _getBluetoothDevicesList(state.feeders);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _getBluetoothDevicesList(List<BluetoothDiscoveryResult> feeders) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: feeders.length,
            itemBuilder: (BuildContext context, index) {
              BluetoothDiscoveryResult result = feeders[index];
              final device = result.device;
              return BluetoothDeviceListEntry(
                device: device,
                rssi: result.rssi,
                onTap: () {
                  BlocProvider.of<PairFeedersBloc>(context)
                      .add(PairNewFeederEvent(device: result.device));
                },
              );
            },
          ),
        )
      ],
    );
  }
}
