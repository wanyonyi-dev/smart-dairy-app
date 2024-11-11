import 'package:cloud_firestore/cloud_firestore.dart';

class InseminationRecord {
  final String id; // Add an ID field
  final String cowId;
  final DateTime inseminationDate;
  final String semenBatch;
  final String technician;
  final String? remarks;
  final String semenCompany;
  final String bullName;
  final String tagNo;
  final String lactationNo;
  final String? breed; // Ensure breed is included

  InseminationRecord({
    required this.id,
    required this.cowId,
    required this.inseminationDate,
    required this.semenBatch,
    required this.technician,
    this.remarks,
    required this.semenCompany,
    required this.bullName,
    required this.tagNo,
    required this.lactationNo,
    this.breed,
  });

  factory InseminationRecord.fromFirestore(Map<String, dynamic> data, String id) {
    return InseminationRecord(
      id: id,
      cowId: data['cowId'] as String,
      inseminationDate: (data['inseminationDate'] as Timestamp).toDate(),
      semenBatch: data['semenBatch'] as String,
      technician: data['technician'] as String,
      remarks: data['remarks'] as String?,
      semenCompany: data['semenCompany'] as String,
      bullName: data['bullName'] as String,
      tagNo: data['tagNo'] as String,
      lactationNo: data['lactationNo'] as String,
      breed: data['breed'] as String?, // Parse breed from Firestore
    );
  }
}
