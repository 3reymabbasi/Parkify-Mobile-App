import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportViewModel extends ChangeNotifier {
  String _selectedType = '';
  Uint8List? _imageBytes;

  String get selectedType => _selectedType;
  Uint8List? get imageBytes => _imageBytes;
  bool get canSubmit => _selectedType.isNotEmpty;

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

  void reset() {
    _selectedType = '';
    _imageBytes = null;
    notifyListeners();
  }
}
