import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../provider/sample_provider.dart';
import '/core/constants/api_endpoint.dart';

final carouselProvider =
    StateNotifierProvider<CarouselController, List<String>>(
  (ref) => CarouselController(ref),
);

class CarouselController extends StateNotifier<List<String>> {
  final Ref ref;

  CarouselController(this.ref) : super([]) {
    fetchCarousels();
  }

  Future<void> fetchCarousels() async {
    final authToken = ref.read(sampleProvider);
    const String url = "$mainUrl/admin/config/carousels";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $authToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> carousels = data["carousels"];
        state = carousels.map<String>((carousel) => carousel["path"]).toList();
      } else {
        throw Exception("Failed to load carousels");
      }
    } catch (e) {
      state = [];
      throw Exception("Error fetching carousels: $e");
    }
  }
}
