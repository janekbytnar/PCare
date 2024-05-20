class Meal {
  final String? mealName;
  final DateTime? shouldEatAt;
  final bool? isAte;
  final DateTime? ateAt;

  Meal({
    this.mealName,
    this.shouldEatAt,
    this.isAte,
    this.ateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'food': mealName,
      'shouldEatAt': shouldEatAt,
      'ate': isAte,
      'ateAt': ateAt,
    };
  }

  Meal.fromMap(Map<String, dynamic> mealMap)
      : mealName = mealMap["mealName"],
        shouldEatAt = mealMap["shouldEatAt"] != null
            ? DateTime.parse(mealMap["shouldEatAt"])
            : null,
        isAte = mealMap["ate"],
        ateAt =
            mealMap["ateAt"] != null ? DateTime.parse(mealMap["ateAt"]) : null;
}
