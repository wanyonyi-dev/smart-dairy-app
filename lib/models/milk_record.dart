class MilkRecord {
  final String cowId;
  final String cowName;
  final String session; // Morning, Afternoon, Evening
  final double amount; // Amount of milk produced
  final DateTime date; // Date of the record

  MilkRecord({
    required this.cowId,
    required this.cowName,
    required this.session,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'cowId': cowId,
      'cowName': cowName,
      'session': session,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory MilkRecord.fromMap(Map<String, dynamic> map) {
    return MilkRecord(
      cowId: map['cowId'],
      cowName: map['cowName'],
      session: map['session'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
