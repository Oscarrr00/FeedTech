import 'package:feedtech/blocs/feeders/bloc/pair_feeders_bloc.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/pages/feeder_details_page.dart';
import 'package:feedtech/pages/pair_new_feeder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<PairFeedersBloc>().add(LoadUserFeedersEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text("Feeders"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => PairNewFeederPage()),
                  ),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<PairFeedersBloc, FeedersState>(
        builder: (context, state) {
          if (state is LoadingUserFeedersState ||
              state is DiscoveringFeedersState ||
              state is FinishedDiscoveringFeedersState ||
              state is BluetoothErrorFeederState ||
              state is PairingFeederState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FeedersLoadedState) {
            return _getFeedersList(state.userFeeders);
          } else if (state is UserHasNoFeedersState) {
            return _getNoFeedersWidget(context);
          }
          return Container();
        },
      ),
    );
  }

  Widget _getFeedersList(List<Feeder> feeders) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: feeders.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeederDetailsPage(
                        feeder: feeders[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.food_bank),
                    title: Text(feeders[index].feederName),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _getNoFeedersWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No tienes ningun alimentador',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => PairNewFeederPage()),
                  ),
                );
              },
              child: Text(
                'Agrega uno!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ))
        ],
      ),
    );
  }
}
