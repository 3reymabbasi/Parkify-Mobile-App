import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/report_service.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  String _selectedType = '';
  Uint8List? _imageBytes;
  bool _loading = false;
  List<Map<String, dynamic>> _myReports = [];

  bool _reportsLoading = false;
  String? _reportsError;

  String get selectedType => _selectedType;
  Uint8List? get imageBytes => _imageBytes;
  bool get canSubmit => _selectedType.isNotEmpty;
  bool get loading => _loading;
  List<Map<String, dynamic>> get myReports => List.unmodifiable(_myReports);

  bool get reportsLoading => _reportsLoading;
  String? get reportsError => _reportsError;

  void selectType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      _imageBytes = await pickedFile.readAsBytes();
      notifyListeners();
    }
  }

  Future<bool> submitReportToFirebase({
    required String title,
    required String description,
    required String location,
  }) async {
    if (_selectedType.isEmpty) return false;

    _loading = true;
    notifyListeners();

    final id = await _reportService.submitReport(
      type: _selectedType,
      title: title,
      description: description,
      location: location,
    );

    _loading = false;
    notifyListeners();

    if (id != null) {
      reset();
      return true;
    }
    return false;
  }

  void loadMyReports() {
    _reportsLoading = true;
    _reportsError = null;
    notifyListeners();

    _reportService.getMyReports().listen(
      (list) {
        _myReports = list;
        _reportsLoading = false;
        _reportsError = null;
        notifyListeners();
      },
      onError: (e) {
        _myReports = [];
        _reportsLoading = false;
        _reportsError = e.toString();
        notifyListeners();
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    if (status.isEmpty) return 'Unknown';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  void reset() {
    _selectedType = '';
    _imageBytes = null;
    notifyListeners();
  }
}
