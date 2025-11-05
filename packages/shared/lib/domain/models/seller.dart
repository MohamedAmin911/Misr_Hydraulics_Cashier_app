import 'package:freezed_annotation/freezed_annotation.dart';
part 'seller.freezed.dart';
part 'seller.g.dart';

@freezed
abstract class Seller with _$Seller {
  const factory Seller({
    String? id,
    required String name, // same as id
    required String password, // plain text as requested
    required String branch, // الفرع
    @Default(0) int invoiceCount, // عدد الفواتير
    @TimestampConverter() DateTime? createdAt,
  }) = _Seller;

  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();
  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.tryParse(json);
    try {
      final seconds = (json as dynamic).seconds as int;
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } catch (_) {
      return null;
    }
  }

  @override
  Object? toJson(DateTime? date) => date?.toIso8601String();
}
