import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String name, String sugars, int strength) async {
    return await brewCollection
        .doc(uid)
        .set({'name': name, 'sugars': sugars, 'strength': strength});
  }

  // Brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          name: (doc.data() as dynamic)['name'] ?? '',
          sugars: (doc.data() as dynamic)['sugars'] ?? '',
          strength: (doc.data() as dynamic)['strength'] ?? 0);
    }).toList();
  }

  // User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: (snapshot.data() as dynamic)['name'],
        sugars: (snapshot.data() as dynamic)['sugars'],
        strength: (snapshot.data() as dynamic)['strength']);
  }

  // Get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // Get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
