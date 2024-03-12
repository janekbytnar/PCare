import 'package:perfect_childcare/models/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parent {
  final String? uid;
  final String? firstName;
  final String? surname;
  final String? imgUrl;
  final List<Child>? childrens;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Parent({
    this.uid,
    this.firstName,
    this.surname,
    this.imgUrl,
    this.childrens,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'childrens': childrens
          ?.map((child) => child.toMap())
          .toList(), // Konwersja listy dzieci na listę map
      'createdAt': createdAt
          ?.toIso8601String(), // Konwersja daty utworzenia na string w formacie ISO 8601
      'updatedAt': updatedAt
          ?.toIso8601String(), // Konwersja daty aktualizacji na string w formacie ISO 8601
    };
  }

  Parent.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        firstName = doc.data()!["firstName"],
        surname = doc.data()!["surname"],
        imgUrl = doc.data()!["imgUrl"],
        childrens = (doc.data()?["childrens"] as List<dynamic>?)
            ?.map((childData) => Child.fromMap(childData))
            .toList(),
        createdAt = doc.data()?["createdAt"] != null
            ? DateTime.parse(doc.data()?["createdAt"])
            : null,
        updatedAt = doc.data()?["updatedAt"] != null
            ? DateTime.parse(doc.data()?["updatedAt"])
            : null;
}
