import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportViewModel extends ChangeNotifier {
  String _selectedType = '';
  File? _image;

  String get selectedType => _selectedType;
  File? get image => _image;
  bool get canSubmit => _selectedType.isNotEmpty;

  void selectType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  void reset() {
    _selectedType = '';
    _image = null;
    notifyListeners();
  }
}
