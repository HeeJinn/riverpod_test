import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_test/providers/carts_provider.dart';
import 'package:riverpod_test/providers/product_provider.dart';
import 'package:riverpod_test/screens/second_screen.dart';
import 'package:riverpod_test/screens/third_screen.dart';

class FirstScreen extends ConsumerWidget {
  static const routeName = '/first';
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productsProvider);
    final cartsProducts = ref.watch(cartProvider).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiverPod', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              context.push(SecondScreen.routeName);
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              context.push(ThirdScreen.routeName);
            },
            icon: const Icon(Icons.api_outlined, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: allProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      allProducts[index].image,
                      width: 60,
                      height: 60,
                    ),
                    Text(allProducts[index].title),
                    Text('£${allProducts[index].price}'),
                    if (cartsProducts.contains(allProducts[index]))
                      TextButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeProduct(allProducts[index]);
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (!cartsProducts.contains(allProducts[index]))
                      TextButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .addProduct(allProducts[index]);
                        },
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
