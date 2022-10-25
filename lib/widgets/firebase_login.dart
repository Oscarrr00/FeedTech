import 'package:feedtech/pages/logged_page.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class FirebaseLogin extends StatelessWidget {
  FirebaseLogin({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                '563680110173-iabqtug53s4mqe64cubi2ups5s3te1d6.apps.googleusercontent.com',
          ),
          FacebookProviderConfiguration(
            clientId: 'e2072d11ae98b48c1f92953fd35c7807',
          ),
        ],
            actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoggedPage(),
              ),
            );
          }),
        ]));
  }
}

// https://firebase.flutter.dev/docs/ui/auth
