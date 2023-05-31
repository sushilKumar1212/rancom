import 'package:flutter/material.dart';

class JobPostController extends ChangeNotifier {
  int currentPage = 0;

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }
}
