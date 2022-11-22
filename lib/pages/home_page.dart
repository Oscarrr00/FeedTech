import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_bloc.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/pages/admin_page.dart';
import 'package:feedtech/pages/feeder_details_page.dart';
import 'package:feedtech/pages/pair_new_feeder_page.dart';
import 'package:feedtech/widgets/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool> checkAdmin() async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((documentSnapshot) {
    {
      Map<String, dynamic> user = documentSnapshot.data()!;
      if (user["admin"]) {
        return true;
      }
    }
  });
  return false;
}

Future<bool> admin = checkAdmin();

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool admin = false;
  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<bool> checkAdmin() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((documentSnapshot) {
      {
        Map<String, dynamic>? user = documentSnapshot.data();
        if (user == null) {
          return false;
        }
        if (user["admin"]) {
          return true;
        } else {
          return false;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAdmin().then((value) => setState(
          () {
            admin = value;
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feeders"),
        actions: [
          (admin)
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => AdminPage()),
                      ),
                    );
                  },
                  icon: Icon(Icons.person_rounded))
              : SizedBox(),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => PairNewFeederPage()),
                  ),
                );
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                _logout();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => FirebaseLogin()),
                  ),
                );
              },
              icon: Icon(Icons.logout))
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
