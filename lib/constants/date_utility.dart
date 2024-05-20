int? getAge(DateTime? dOB) {
  if (dOB != null) {
    final now = DateTime.now();
    final difference = now.difference(dOB);
    return (difference.inDays / 365).floor();
  }
  return null;
}
