import 'package:perfect_childcare/models/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfect_childcare/models/userData.dart';

class Parent extends UserData {
  final List<Child>? childrens;
  final String? partnerId;

  Parent({
    String? firstName,
    String? surname,
    String? imgUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.childrens,
    this.partnerId,
  }) : super(
          firstName: firstName,
          surname: surname,
        );

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'childrens': childrens
          ?.map((child) => child.toMap())
          .toList(), // Conversion child/s for List
      'createdAt': createdAt?.toIso8601String(), // Conversion date to String
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Parent.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : childrens = (doc.data()?["childrens"] as List<dynamic>?)
            ?.map((childData) => Child.fromMap(childData))
            .toList(),
        partnerId = doc.data()?["partnerId"];
}
