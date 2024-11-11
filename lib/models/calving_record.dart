
class CalvingRecord {
  String? id; // Add this line
  final String cowId;
  final DateTime calvingDate;
  final String calfId;
  final String calvingOutcome;
  final String? remarks;

  CalvingRecord({
    this.id,
    required this.cowId,
    required this.calvingDate,
    required this.calfId,
    required this.calvingOutcome,
    this.remarks,
  });
}
