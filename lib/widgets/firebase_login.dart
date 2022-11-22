import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedtech/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';

import '../blocs/feeders/bloc/pair_feeders_bloc.dart';

class FirebaseLogin extends StatelessWidget {
  FirebaseLogin({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<void> _createUserCollectionFirebase() async {
      var userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // Si no exite el doc, lo crea con valor default lista vacia
      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(
          {
            "admin": false,
            "userId": FirebaseAuth.instance.currentUser!.uid,
          },
        );
      } else {
        // Si ya existe el doc return
        return;
      }
    }

    return Center(
        child: SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('FeedTech',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Image.asset("assets/images/logo.jpg",
                        height: 80, width: 150),
                  ],
                ),
              );
            },
            providerConfigs: [
          EmailProviderConfiguration(),
          GoogleProviderConfiguration(
            clientId:
                '555566114591-isf6l19ke68lcifbk942v4ha8foj8dvc.apps.googleusercontent.com',
          ),
          FacebookProviderConfiguration(
            clientId: 'e2072d11ae98b48c1f92953fd35c7807',
          ),
        ],
            actions: [
          AuthStateChangeAction<SignedIn>((context, state) async {
            await _createUserCollectionFirebase();
            context.read<PairFeedersBloc>().add(LoadUserFeedersEvent());
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }),
        ]));
  }
}

// https://firebase.flutter.dev/docs/ui/auth
