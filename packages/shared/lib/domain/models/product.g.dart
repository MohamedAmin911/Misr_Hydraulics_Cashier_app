// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String?,
  name: json['name'] as String,
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String,
  description: json['description'] as String? ?? '',
  buyPrice: (json['buyPrice'] as num).toDouble(),
  sellPrice: (json['sellPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'description': instance.description,
  'buyPrice': instance.buyPrice,
  'sellPrice': instance.sellPrice,
  'quantity': instance.quantity,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
