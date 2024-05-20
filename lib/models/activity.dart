class Activity {
  final String? activityTitle;
  final String? description;
  final bool? isDone;
  final DateTime? doneAt;
  final DateTime? createdAt;

  Activity({
    this.activityTitle,
    this.description,
    this.isDone,
    this.doneAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityTitle': activityTitle,
      'description': description,
      'done': isDone,
      'doneAt': doneAt,
      'createdAt': createdAt,
    };
  }

  Activity.fromMap(Map<String, dynamic> activityMap)
      : activityTitle = activityMap["activityTitle"],
        description = activityMap["description"],
        isDone = activityMap["done"],
        doneAt = activityMap["doneAt"] != null
            ? DateTime.parse(activityMap["doneAt"])
            : null,
        createdAt = activityMap["createdAt"] != null
            ? DateTime.parse(activityMap["createdAt"])
            : null;
}
