import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Services/network/api.dart';

final apiService = Provider((ref) {
  return ApiService();
});
