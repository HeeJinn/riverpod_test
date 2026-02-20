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
      // 1. Use a clear, large Title for mobile readability
      appBar: AppBar(
        title: const Text('Store Inventory'),
        centerTitle: true, // Standard for iOS look
      ),
      body: apiProducts.when(
        data: (data) {
          return ListView.builder(
            // 2. Add some breathing room around the list
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final product = data[index];
              
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  // 3. Swap 'Row' for 'Column' + 'Expanded' to prevent horizontal overflow
                  child: Row(
                    children: [
                      // Circular Badge for ID (Android/iOS common style)
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Text('${product.id}', style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 16),
                      
                      // Use Expanded to let the text wrap instead of breaking the screen
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Adds "..." if too long
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category.toUpperCase(),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      
                      // Price on the right side
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '£${product.price}',
                            style: const TextStyle(
                              color: Colors.green, 
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: LoadingIndicatorM3E()),
      ),
    );
  }
}