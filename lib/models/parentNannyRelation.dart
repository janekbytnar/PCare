class ParentNannyRelation {
  final String? parentUid;
  final String? nannyUid;

  ParentNannyRelation({
    this.parentUid,
    this.nannyUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentUid': parentUid,
      'nannyUid': nannyUid,
    };
  }

  ParentNannyRelation.fromMap(Map<String, dynamic> parentNannyRelationMap)
      : parentUid = parentNannyRelationMap["parentUid"],
        nannyUid = parentNannyRelationMap["nannyUid"];
}
