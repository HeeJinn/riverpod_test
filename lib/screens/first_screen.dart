import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_test/providers/carts_provider.dart';
import 'package:riverpod_test/providers/product_provider.dart';
import 'package:riverpod_test/screens/fourt_screen.dart';
import 'package:riverpod_test/screens/second_screen.dart';
import 'package:riverpod_test/screens/third_screen.dart';

class FirstScreen extends ConsumerWidget {
  static const routeName = '/first';
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productsProvider);
    final cartsProducts = ref.watch(cartProvider).toList();
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RiverPod', style: TextStyle(color: Colors.white)),
        centerTitle: isIOS,
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
          IconButton(
            onPressed: () {
              context.push(FourtScreen.routeName);
            },
            icon: const Icon(Icons.share_outlined, color: Colors.white),
          ),
        ],
        backgroundColor: isIOS ? CupertinoColors.systemBlue : Colors.deepPurple,
        elevation: isIOS ? 0 : 4,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 2;
            if (width >= 1200) {
              crossAxisCount = 5;
            } else if (width >= 900) {
              crossAxisCount = 4;
            } else if (width >= 600) {
              crossAxisCount = 3;
            }

            // childAspectRatio tuned to keep cards visually balanced across sizes
            final childAspectRatio = (width / crossAxisCount) / 260;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width < 400 ? 12.0 : 20.0,
                vertical: 12.0,
              ),
              child: GridView.builder(
                itemCount: allProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final product = allProducts[index];
                  final inCart = cartsProducts.contains(product);
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '£${product.price}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          // Platform-adaptive action button
                          if (isIOS)
                            CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              onPressed: () {
                                if (inCart) {
                                  ref
                                      .read(cartProvider.notifier)
                                      .removeProduct(product);
                                } else {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addProduct(product);
                                }
                              },
                              child: Text(
                                inCart ? 'Remove' : 'Add to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          else
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: inCart
                                    ? Colors.redAccent
                                    : Colors.green,
                                minimumSize: const Size.fromHeight(36),
                              ),
                              onPressed: () {
                                if (inCart) {
                                  ref
                                      .read(cartProvider.notifier)
                                      .removeProduct(product);
                                } else {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addProduct(product);
                                }
                              },
                              child: Text(
                                inCart ? 'Remove' : 'Add to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
