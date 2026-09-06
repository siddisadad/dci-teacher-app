import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendance {
  final String id;
  final String studentId;
  final String studentName;
  final String className;
  final String subject;
  final String status;
  final DateTime date;
  final String markedBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  StudentAttendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.className,
    required this.subject,
    required this.status,
    required this.date,
    required this.markedBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory StudentAttendance.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return StudentAttendance(
      id: doc.id,
      studentId: data['studentId']?.toString() ?? '',
      studentName: data['studentName']?.toString() ?? '',
      className: data['class']?.toString() ?? '',
      subject: data['subject']?.toString() ?? '',
      status: data['status']?.toString() ?? 'Present',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      markedBy: data['markedBy']?.toString() ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedBy: data['updatedBy']?.toString(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'class': className,
      'subject': subject,
      'status': status,
      'date': Timestamp.fromDate(date),
      'markedBy': markedBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }
}
