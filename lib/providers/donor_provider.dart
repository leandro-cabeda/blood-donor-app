import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../services/api_service.dart';

class DonorProvider with ChangeNotifier {
  List<Donor> _donors = [];
  final ApiService apiService = ApiService();

  List<Donor> get donors => _donors;

  Future<void> loadDonors() async {
    _donors = await apiService.fetchDonors();
    notifyListeners();
  }

  Future<void> postDonor(Donor donor) async {
    await apiService.postDonor(donor);
    _donors.add(donor);
    notifyListeners();
  }
}
