import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/models/api_model.dart';
part 'api_provider.g.dart';

@riverpod
FutureOr<List<ApiProduct>> apiProducts(Ref ref) async {
  final response = await http.get(
    Uri.parse('https://dummyjson.com/products'), // Remove the /1
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    // Extract the list from the "products" key
    final List<dynamic> productList = jsonData['products'];

    return productList.map((item) => ApiProduct.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
