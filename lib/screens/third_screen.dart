import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:riverpod_test/providers/api_provider.dart';

class ThirdScreen extends ConsumerWidget {
  static const String routeName = '/third';
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiProducts = ref.watch(apiProductsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Third Screen')),
      body: apiProducts.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final product = data[index];
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('ID: ${product.id}'),
                      Text('Title: ${product.title}'),
                      Text('Price: £${product.price}'),
                      Text('Category: ${product.category}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error loading products: $error'));
        },
        loading: () {
          return Center(child: LoadingIndicatorM3E());
        },
      ),
    );
  }
}
