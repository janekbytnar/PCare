class Payment {
  final String? parentUid;
  final String? nannyUid;
  final double? perHour;
  final double? hours;
  final bool? isPaid;

  Payment({
    this.parentUid,
    this.nannyUid,
    this.perHour,
    this.hours,
    this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentUid': parentUid,
      'nannyUid': nannyUid,
      'perHour': perHour,
      'hours': hours,
      'paid': isPaid,
    };
  }

  Payment.fromMap(Map<String, dynamic> paymentMap)
      : parentUid = paymentMap["paymentMap"],
        nannyUid = paymentMap["nannyUid"],
        perHour = paymentMap["perHour"],
        hours = paymentMap["hours"],
        isPaid = paymentMap["paid"];
}
