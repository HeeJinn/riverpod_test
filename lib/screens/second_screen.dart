import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/carts_provider.dart';

class SecondScreen extends ConsumerStatefulWidget {
  static const routeName = '/second';
  const SecondScreen({super.key});

  @override
  ConsumerState<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen> {
  bool showCoupon = true;

  @override
  Widget build(BuildContext context) {
    final cartProducts = ref.watch(cartProvider).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        // actions: [],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: ListView.builder(
          itemCount: cartProducts.length,
          itemBuilder: (context, index) {
            final product = cartProducts[index];
            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(product.image, width: 60, height: 60),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title),
                        Text('£${product.price}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: TextButton(
        onPressed: () {},
        child: Text('Total: £${ref.watch(cartTotalProvider)}'),
      ),
    );
  }
}
