class Observation {
  final String? observationTitle;
  final String? description;
  final DateTime? createdAt;
  final bool? isRead;

  Observation({
    this.observationTitle,
    this.description,
    this.createdAt,
    this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'observationTitle': observationTitle,
      'description': description,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  Observation.fromMap(Map<String, dynamic> observationMap)
      : observationTitle = observationMap["observationTitle"],
        description = observationMap["description"],
        createdAt = observationMap["createdAt"] != null
            ? DateTime.parse(observationMap["createdAt"])
            : null,
        isRead = observationMap["isRead"];
}
