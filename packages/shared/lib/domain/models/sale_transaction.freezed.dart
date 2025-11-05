// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleTransaction {

 String? get id;@TimestampConverter() DateTime get date; String get sellerId; List<TransactionItem> get items; double get totalSell; double get totalCost; double get totalProfit;
/// Create a copy of SaleTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleTransactionCopyWith<SaleTransaction> get copyWith => _$SaleTransactionCopyWithImpl<SaleTransaction>(this as SaleTransaction, _$identity);

  /// Serializes this SaleTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalSell, totalSell) || other.totalSell == totalSell)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,sellerId,const DeepCollectionEquality().hash(items),totalSell,totalCost,totalProfit);

@override
String toString() {
  return 'SaleTransaction(id: $id, date: $date, sellerId: $sellerId, items: $items, totalSell: $totalSell, totalCost: $totalCost, totalProfit: $totalProfit)';
}


}

/// @nodoc
abstract mixin class $SaleTransactionCopyWith<$Res>  {
  factory $SaleTransactionCopyWith(SaleTransaction value, $Res Function(SaleTransaction) _then) = _$SaleTransactionCopyWithImpl;
@useResult
$Res call({
 String? id,@TimestampConverter() DateTime date, String sellerId, List<TransactionItem> items, double totalSell, double totalCost, double totalProfit
});




}
/// @nodoc
class _$SaleTransactionCopyWithImpl<$Res>
    implements $SaleTransactionCopyWith<$Res> {
  _$SaleTransactionCopyWithImpl(this._self, this._then);

  final SaleTransaction _self;
  final $Res Function(SaleTransaction) _then;

/// Create a copy of SaleTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? date = null,Object? sellerId = null,Object? items = null,Object? totalSell = null,Object? totalCost = null,Object? totalProfit = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,totalSell: null == totalSell ? _self.totalSell : totalSell // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleTransaction].
extension SaleTransactionPatterns on SaleTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleTransaction value)  $default,){
final _that = this;
switch (_that) {
case _SaleTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _SaleTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @TimestampConverter()  DateTime date,  String sellerId,  List<TransactionItem> items,  double totalSell,  double totalCost,  double totalProfit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleTransaction() when $default != null:
return $default(_that.id,_that.date,_that.sellerId,_that.items,_that.totalSell,_that.totalCost,_that.totalProfit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @TimestampConverter()  DateTime date,  String sellerId,  List<TransactionItem> items,  double totalSell,  double totalCost,  double totalProfit)  $default,) {final _that = this;
switch (_that) {
case _SaleTransaction():
return $default(_that.id,_that.date,_that.sellerId,_that.items,_that.totalSell,_that.totalCost,_that.totalProfit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @TimestampConverter()  DateTime date,  String sellerId,  List<TransactionItem> items,  double totalSell,  double totalCost,  double totalProfit)?  $default,) {final _that = this;
switch (_that) {
case _SaleTransaction() when $default != null:
return $default(_that.id,_that.date,_that.sellerId,_that.items,_that.totalSell,_that.totalCost,_that.totalProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleTransaction implements SaleTransaction {
  const _SaleTransaction({this.id, @TimestampConverter() required this.date, required this.sellerId, required final  List<TransactionItem> items, required this.totalSell, required this.totalCost, required this.totalProfit}): _items = items;
  factory _SaleTransaction.fromJson(Map<String, dynamic> json) => _$SaleTransactionFromJson(json);

@override final  String? id;
@override@TimestampConverter() final  DateTime date;
@override final  String sellerId;
 final  List<TransactionItem> _items;
@override List<TransactionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalSell;
@override final  double totalCost;
@override final  double totalProfit;

/// Create a copy of SaleTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleTransactionCopyWith<_SaleTransaction> get copyWith => __$SaleTransactionCopyWithImpl<_SaleTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalSell, totalSell) || other.totalSell == totalSell)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,sellerId,const DeepCollectionEquality().hash(_items),totalSell,totalCost,totalProfit);

@override
String toString() {
  return 'SaleTransaction(id: $id, date: $date, sellerId: $sellerId, items: $items, totalSell: $totalSell, totalCost: $totalCost, totalProfit: $totalProfit)';
}


}

/// @nodoc
abstract mixin class _$SaleTransactionCopyWith<$Res> implements $SaleTransactionCopyWith<$Res> {
  factory _$SaleTransactionCopyWith(_SaleTransaction value, $Res Function(_SaleTransaction) _then) = __$SaleTransactionCopyWithImpl;
@override @useResult
$Res call({
 String? id,@TimestampConverter() DateTime date, String sellerId, List<TransactionItem> items, double totalSell, double totalCost, double totalProfit
});




}
/// @nodoc
class __$SaleTransactionCopyWithImpl<$Res>
    implements _$SaleTransactionCopyWith<$Res> {
  __$SaleTransactionCopyWithImpl(this._self, this._then);

  final _SaleTransaction _self;
  final $Res Function(_SaleTransaction) _then;

/// Create a copy of SaleTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? date = null,Object? sellerId = null,Object? items = null,Object? totalSell = null,Object? totalCost = null,Object? totalProfit = null,}) {
  return _then(_SaleTransaction(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,totalSell: null == totalSell ? _self.totalSell : totalSell // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
