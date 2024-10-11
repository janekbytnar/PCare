import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfect_childcare/models/userData.dart';

class Nanny extends UserData {
  final DateTime? experience;
  final int? perHour;

  Nanny({
    String? firstName,
    String? surname,
    String? imgUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.experience,
    this.perHour,
  }) : super(
          firstName: firstName,
          surname: surname,
          createdAt: createdAt,
        );

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'experience': experience,
      'createdAt': createdAt?.toIso8601String(), // Conversion date to String
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Nanny.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : experience = doc.data()?['experience'] != null
            ? DateTime.parse(doc.data()?['experience'])
            : null,
        perHour = doc.data()?['perHour'];
}
