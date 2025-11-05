import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_item.dart';

part 'sale_transaction.freezed.dart';
part 'sale_transaction.g.dart';

@freezed
abstract class SaleTransaction with _$SaleTransaction {
  const factory SaleTransaction({
    String? id,
    @TimestampConverter() required DateTime date,
    required String sellerId,
    required List<TransactionItem> items,
    required double totalSell,
    required double totalCost,
    required double totalProfit,
  }) = _SaleTransaction;

  factory SaleTransaction.fromJson(Map<String, dynamic> json) =>
      _$SaleTransactionFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();
  @override
  DateTime fromJson(Object? json) {
    if (json == null) return DateTime.now();
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.tryParse(json) ?? DateTime.now();
    try {
      final seconds = (json as dynamic).seconds as int;
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  Object? toJson(DateTime date) => date.toIso8601String();
}
