import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/shared.dart';

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super(const []);

  void addOrUpdate({
    required String productId,
    required String name,
    required double sellPrice,
    required int addQuantity,
    required int maxAvailable,
  }) {
    final list = [...state];
    final idx = list.indexWhere((e) => e.productId == productId);
    if (idx >= 0) {
      final current = list[idx];
      final newQty = (current.quantity + addQuantity).clamp(1, maxAvailable);
      list[idx] = current.copyWith(quantity: newQty);
    } else {
      list.add(
        CartItem(
          productId: productId,
          productName: name,
          sellPrice: sellPrice,
          quantity: addQuantity.clamp(1, maxAvailable),
        ),
      );
    }
    state = list;
  }

  void increment(String productId, {required int maxAvailable}) {
    final list = [...state];
    final idx = list.indexWhere((e) => e.productId == productId);
    if (idx >= 0) {
      final it = list[idx];
      final newQty = (it.quantity + 1).clamp(1, maxAvailable);
      list[idx] = it.copyWith(quantity: newQty);
      state = list;
    }
  }

  void decrement(String productId) {
    final list = [...state];
    final idx = list.indexWhere((e) => e.productId == productId);
    if (idx >= 0) {
      final it = list[idx];
      final newQty = it.quantity - 1;
      if (newQty <= 0) {
        list.removeAt(idx);
      } else {
        list[idx] = it.copyWith(quantity: newQty);
      }
      state = list;
    }
  }

  void remove(String productId) {
    state = state.where((e) => e.productId != productId).toList();
  }

  void clear() => state = const [];
}

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>((
  ref,
) {
  return CartController();
});

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, e) => sum + e.sellPrice * e.quantity);
});
