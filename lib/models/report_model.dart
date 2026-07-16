import 'dart:io';

class ReportModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final String location;
  final File? image;
  final DateTime submittedAt;
  final String status; // Pending, Reviewed, Resolved

  ReportModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    this.image,
    required this.submittedAt,
    this.status = 'Pending',
  });
}
