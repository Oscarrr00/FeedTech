import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feeder {
  final String feederId;
  final String feederName;
  final String ownerId;
  final String? feedTimes;
  final int? portions;

  Feeder({
    required this.feederId,
    required this.ownerId,
    required this.feederName,
  })  : feedTimes = null,
        portions = null;

  Feeder.fromMap(Map<String, dynamic> feederDoc)
      : feederId = feederDoc['feederId'],
        feederName = feederDoc['feederName'],
        feedTimes = feederDoc['feedTimes'],
        portions = feederDoc['portions'],
        ownerId = feederDoc['ownerId'];
}

class SharedUserFeederRecord {
  final String userId;
  final DocumentReference<Map<String, dynamic>> feeder;

  SharedUserFeederRecord({
    required this.feeder,
    required this.userId,
  });

  SharedUserFeederRecord.fromMap(Map<String, dynamic> feederDoc)
      : userId = feederDoc['userId'],
        feeder = feederDoc['feeder'];
}

class FeedersRepository {
  Future<Feeder> createFirestoreFeeder(
    String feederName,
  ) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw 'No user logged in';
    }
    final Map<String, dynamic> feederToInsert = {
      'feederName': feederName,
      'ownerId': uid,
    };
    final insertedFeeder = await FirebaseFirestore.instance
        .collection("feeders")
        .add(feederToInsert);
    return Feeder.fromMap(
        feederToInsert..addEntries({'feederId': insertedFeeder.id}.entries));
  }

  Future<Feeder?> getFirestoreFeederById(String feederId) async {
    final feedersQuery = await FirebaseFirestore.instance
        .collection("feeders")
        .doc(feederId)
        .get();
    if (feedersQuery.exists == false) {
      return null;
    }

    return Feeder.fromMap(feedersQuery.data()!
      ..addEntries({'feederId': feedersQuery.id}.entries));
  }

  Future<List<Feeder>> getAllUserFeeders() async {
    final ownUserFeedersQuery = await FirebaseFirestore.instance
        .collection("feeders")
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    final ownedUserFeeders = ownUserFeedersQuery.docs
        .map((doc) => Feeder.fromMap(
            doc.data()..addEntries({'feederId': doc.id}.entries)))
        .toList();

    final sharedUserFeedersRefsQuery = await FirebaseFirestore.instance
        .collection("feeders_users")
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    final sharedUserFeedersRefs = sharedUserFeedersRefsQuery.docs
        .map((doc) => SharedUserFeederRecord.fromMap(doc.data()))
        .toList();

    final sharedUserFeedersQuery = await Future.wait(sharedUserFeedersRefs
        .map(
          (docRef) => docRef.feeder.get(),
        )
        .toList());
    final sharedUserFeeders = sharedUserFeedersQuery
        .map((doc) => Feeder.fromMap(
            doc.data()!..addEntries({'feederId': doc.id}.entries)))
        .toList();
    return [...ownedUserFeeders, ...sharedUserFeeders];
  }
}
