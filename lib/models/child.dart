import 'package:perfect_childcare/constants/date_utility.dart';

class Child {
  final String? firstName;
  final String? surname;
  final DateTime? dOB;

  Child({
    this.firstName,
    this.surname,
    this.dOB,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'surname': surname,
      'dOB': dOB?.toIso8601String(),
      'age': getAge(dOB),
    };
  }

  Child.fromMap(Map<String, dynamic> childMap)
      : firstName = childMap["firstName"],
        surname = childMap["surname"],
        dOB = DateTime.parse(
            childMap["dOB"]); // Konwersja stringa na obiekt DateTime
}
