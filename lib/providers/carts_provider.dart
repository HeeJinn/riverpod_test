import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/models/products.dart';
part 'carts_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
   Set<Product>build() {
    return {};
  }

  void addProduct(Product product) {
    if(!state.contains(product)){
      state = {...state, product};
    }

  }

  void removeProduct(Product product){
    if(state.contains(product)){
      state = state.where((p) => p.id != product.id).toSet();

    }
  }
}


@riverpod
int cartTotal(Ref ref) {
  final cartProducts = ref.watch(cartProvider);
  int total = 0;
  for (var product in cartProducts) {
    total += product.price;
  }
  return total;
}