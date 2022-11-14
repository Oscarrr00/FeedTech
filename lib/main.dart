import 'package:feedtech/blocs/feeders/bloc/pair_feeders_bloc.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/pages/home_page.dart';
import 'package:feedtech/pages/login_page.dart';
import 'package:feedtech/pages/feeder_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //inicializar firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await dotenv.load();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => FeedersRepository(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PairFeedersBloc(
              feedersRepository: context.read<FeedersRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home:
          FirebaseAuth.instance.currentUser == null ? LoginPage() : HomePage(),
    );
  }
}
