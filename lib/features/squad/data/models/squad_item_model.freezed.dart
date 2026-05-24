// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'squad_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SquadItemModel _$SquadItemModelFromJson(Map<String, dynamic> json) {
  return _SquadItemModel.fromJson(json);
}

/// @nodoc
mixin _$SquadItemModel {
  @JsonKey(name: 'squad_item_id')
  String get squadItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_cards')
  PlayerCardModel get card => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_index')
  int get slotIndex => throw _privateConstructorUsedError;

  /// Serializes this SquadItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SquadItemModelCopyWith<SquadItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquadItemModelCopyWith<$Res> {
  factory $SquadItemModelCopyWith(
    SquadItemModel value,
    $Res Function(SquadItemModel) then,
  ) = _$SquadItemModelCopyWithImpl<$Res, SquadItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'squad_item_id') String squadItemId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'player_cards') PlayerCardModel card,
    String position,
    @JsonKey(name: 'slot_index') int slotIndex,
  });

  $PlayerCardModelCopyWith<$Res> get card;
}

/// @nodoc
class _$SquadItemModelCopyWithImpl<$Res, $Val extends SquadItemModel>
    implements $SquadItemModelCopyWith<$Res> {
  _$SquadItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadItemId = null,
    Object? userId = null,
    Object? card = null,
    Object? position = null,
    Object? slotIndex = null,
  }) {
    return _then(
      _value.copyWith(
            squadItemId: null == squadItemId
                ? _value.squadItemId
                : squadItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            card: null == card
                ? _value.card
                : card // ignore: cast_nullable_to_non_nullable
                      as PlayerCardModel,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
            slotIndex: null == slotIndex
                ? _value.slotIndex
                : slotIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCardModelCopyWith<$Res> get card {
    return $PlayerCardModelCopyWith<$Res>(_value.card, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SquadItemModelImplCopyWith<$Res>
    implements $SquadItemModelCopyWith<$Res> {
  factory _$$SquadItemModelImplCopyWith(
    _$SquadItemModelImpl value,
    $Res Function(_$SquadItemModelImpl) then,
  ) = __$$SquadItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'squad_item_id') String squadItemId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'player_cards') PlayerCardModel card,
    String position,
    @JsonKey(name: 'slot_index') int slotIndex,
  });

  @override
  $PlayerCardModelCopyWith<$Res> get card;
}

/// @nodoc
class __$$SquadItemModelImplCopyWithImpl<$Res>
    extends _$SquadItemModelCopyWithImpl<$Res, _$SquadItemModelImpl>
    implements _$$SquadItemModelImplCopyWith<$Res> {
  __$$SquadItemModelImplCopyWithImpl(
    _$SquadItemModelImpl _value,
    $Res Function(_$SquadItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadItemId = null,
    Object? userId = null,
    Object? card = null,
    Object? position = null,
    Object? slotIndex = null,
  }) {
    return _then(
      _$SquadItemModelImpl(
        squadItemId: null == squadItemId
            ? _value.squadItemId
            : squadItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        card: null == card
            ? _value.card
            : card // ignore: cast_nullable_to_non_nullable
                  as PlayerCardModel,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        slotIndex: null == slotIndex
            ? _value.slotIndex
            : slotIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SquadItemModelImpl extends _SquadItemModel {
  const _$SquadItemModelImpl({
    @JsonKey(name: 'squad_item_id') required this.squadItemId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'player_cards') required this.card,
    required this.position,
    @JsonKey(name: 'slot_index') required this.slotIndex,
  }) : super._();

  factory _$SquadItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SquadItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'squad_item_id')
  final String squadItemId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'player_cards')
  final PlayerCardModel card;
  @override
  final String position;
  @override
  @JsonKey(name: 'slot_index')
  final int slotIndex;

  @override
  String toString() {
    return 'SquadItemModel(squadItemId: $squadItemId, userId: $userId, card: $card, position: $position, slotIndex: $slotIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SquadItemModelImpl &&
            (identical(other.squadItemId, squadItemId) ||
                other.squadItemId == squadItemId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.slotIndex, slotIndex) ||
                other.slotIndex == slotIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, squadItemId, userId, card, position, slotIndex);

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SquadItemModelImplCopyWith<_$SquadItemModelImpl> get copyWith =>
      __$$SquadItemModelImplCopyWithImpl<_$SquadItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SquadItemModelImplToJson(this);
  }
}

abstract class _SquadItemModel extends SquadItemModel {
  const factory _SquadItemModel({
    @JsonKey(name: 'squad_item_id') required final String squadItemId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'player_cards') required final PlayerCardModel card,
    required final String position,
    @JsonKey(name: 'slot_index') required final int slotIndex,
  }) = _$SquadItemModelImpl;
  const _SquadItemModel._() : super._();

  factory _SquadItemModel.fromJson(Map<String, dynamic> json) =
      _$SquadItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'squad_item_id')
  String get squadItemId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'player_cards')
  PlayerCardModel get card;
  @override
  String get position;
  @override
  @JsonKey(name: 'slot_index')
  int get slotIndex;

  /// Create a copy of SquadItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SquadItemModelImplCopyWith<_$SquadItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
