// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    _TransactionItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      buyPriceAtSale: (json['buyPriceAtSale'] as num).toDouble(),
      sellPriceAtSale: (json['sellPriceAtSale'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionItemToJson(_TransactionItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'buyPriceAtSale': instance.buyPriceAtSale,
      'sellPriceAtSale': instance.sellPriceAtSale,
      'quantity': instance.quantity,
    };
