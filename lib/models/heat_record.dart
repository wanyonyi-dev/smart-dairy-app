import 'package:cloud_firestore/cloud_firestore.dart';

class HeatRecord {
  String id;
  String cowId;
  DateTime dateOfHeat;
  Duration duration;
  String heatSigns;
  DateTime? inseminationDate;
  bool? isPregnant;

  HeatRecord({
    required this.id,
    required this.cowId,
    required this.dateOfHeat,
    required this.duration,
    required this.heatSigns,
    this.inseminationDate,
    this.isPregnant,
  });

  // Method to convert Firestore document to HeatRecord object
  factory HeatRecord.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return HeatRecord(
      id: doc.id, // Document ID from Firestore
      cowId: data['cowId'],
      dateOfHeat: (data['dateOfHeat'] as Timestamp).toDate(),
      duration: Duration(hours: data['duration']),
      heatSigns: data['heatSigns'],
      inseminationDate: data['inseminationDate'] != null
          ? (data['inseminationDate'] as Timestamp).toDate()
          : null,
      isPregnant: data['isPregnant'],
    );
  }

  // Method to convert HeatRecord object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'cowId': cowId,
      'dateOfHeat': dateOfHeat,
      'duration': duration.inHours, // Store duration as hours
      'heatSigns': heatSigns,
      'inseminationDate': inseminationDate,
      'isPregnant': isPregnant,
    };
  }
}
