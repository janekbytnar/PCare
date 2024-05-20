import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? username;

  UserData({
    this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': username,
    };
  }

  UserData.fromDocumentSnapshot(

      // if not working try add Data to userDataMap
      // firstName = userDataMap.data()["firstName"],
      DocumentSnapshot<Map<String, dynamic>> username)
      : username = username['firstName'];
}
