import 'dart:io';

class ReportModel {
  final String type;
  final String title;
  final String description;
  final String location;
  final File? image;

  ReportModel({
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    this.image,
  });
}
