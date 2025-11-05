import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item.freezed.dart';
part 'transaction_item.g.dart';

@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String productId,
    required String productName,
    required double buyPriceAtSale,
    required double sellPriceAtSale,
    required int quantity,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);
}
