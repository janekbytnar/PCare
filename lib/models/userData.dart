import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? firstName;
  final String? surname;
  final String? imgUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isNanny;
  final List<String>? sessionID;

  UserData({
    this.firstName,
    this.surname,
    this.imgUrl,
    this.createdAt,
    this.updatedAt,
    this.isNanny,
    this.sessionID,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'createdAt': createdAt?.toIso8601String(), // Conversion date to String
      'updatedAt': updatedAt?.toIso8601String(),
      'nanny': isNanny,
      'sessionID': sessionID,
    };
  }

  UserData.fromDocumentSnapshot(

      // if not working try add Data to userDataMap
      // firstName = userDataMap.data()["firstName"],
      DocumentSnapshot<Map<String, dynamic>> userDataMap)
      : firstName = userDataMap['firstName'],
        surname = userDataMap['surname'],
        imgUrl = userDataMap['imgUrl'],
        createdAt = userDataMap["createdAt"] != null
            ? DateTime.parse(userDataMap["createdAt"])
            : null,
        updatedAt = userDataMap["updatedAt"] != null
            ? DateTime.parse(userDataMap["updatedAt"])
            : null,
        isNanny = userDataMap["nanny"],
        sessionID = List<String>.from(userDataMap["sessionID"]);
}
