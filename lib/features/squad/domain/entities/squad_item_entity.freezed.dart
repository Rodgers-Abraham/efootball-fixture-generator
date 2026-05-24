// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'squad_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SquadItemEntity {
  String get squadItemId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  PlayerCardEntity get card => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  int get slotIndex => throw _privateConstructorUsedError;

  /// Create a copy of SquadItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SquadItemEntityCopyWith<SquadItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquadItemEntityCopyWith<$Res> {
  factory $SquadItemEntityCopyWith(
    SquadItemEntity value,
    $Res Function(SquadItemEntity) then,
  ) = _$SquadItemEntityCopyWithImpl<$Res, SquadItemEntity>;
  @useResult
  $Res call({
    String squadItemId,
    String userId,
    PlayerCardEntity card,
    String position,
    int slotIndex,
  });

  $PlayerCardEntityCopyWith<$Res> get card;
}

/// @nodoc
class _$SquadItemEntityCopyWithImpl<$Res, $Val extends SquadItemEntity>
    implements $SquadItemEntityCopyWith<$Res> {
  _$SquadItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SquadItemEntity
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
                      as PlayerCardEntity,
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

  /// Create a copy of SquadItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCardEntityCopyWith<$Res> get card {
    return $PlayerCardEntityCopyWith<$Res>(_value.card, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SquadItemEntityImplCopyWith<$Res>
    implements $SquadItemEntityCopyWith<$Res> {
  factory _$$SquadItemEntityImplCopyWith(
    _$SquadItemEntityImpl value,
    $Res Function(_$SquadItemEntityImpl) then,
  ) = __$$SquadItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String squadItemId,
    String userId,
    PlayerCardEntity card,
    String position,
    int slotIndex,
  });

  @override
  $PlayerCardEntityCopyWith<$Res> get card;
}

/// @nodoc
class __$$SquadItemEntityImplCopyWithImpl<$Res>
    extends _$SquadItemEntityCopyWithImpl<$Res, _$SquadItemEntityImpl>
    implements _$$SquadItemEntityImplCopyWith<$Res> {
  __$$SquadItemEntityImplCopyWithImpl(
    _$SquadItemEntityImpl _value,
    $Res Function(_$SquadItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SquadItemEntity
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
      _$SquadItemEntityImpl(
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
                  as PlayerCardEntity,
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

class _$SquadItemEntityImpl implements _SquadItemEntity {
  const _$SquadItemEntityImpl({
    required this.squadItemId,
    required this.userId,
    required this.card,
    required this.position,
    required this.slotIndex,
  });

  @override
  final String squadItemId;
  @override
  final String userId;
  @override
  final PlayerCardEntity card;
  @override
  final String position;
  @override
  final int slotIndex;

  @override
  String toString() {
    return 'SquadItemEntity(squadItemId: $squadItemId, userId: $userId, card: $card, position: $position, slotIndex: $slotIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SquadItemEntityImpl &&
            (identical(other.squadItemId, squadItemId) ||
                other.squadItemId == squadItemId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.slotIndex, slotIndex) ||
                other.slotIndex == slotIndex));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, squadItemId, userId, card, position, slotIndex);

  /// Create a copy of SquadItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SquadItemEntityImplCopyWith<_$SquadItemEntityImpl> get copyWith =>
      __$$SquadItemEntityImplCopyWithImpl<_$SquadItemEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _SquadItemEntity implements SquadItemEntity {
  const factory _SquadItemEntity({
    required final String squadItemId,
    required final String userId,
    required final PlayerCardEntity card,
    required final String position,
    required final int slotIndex,
  }) = _$SquadItemEntityImpl;

  @override
  String get squadItemId;
  @override
  String get userId;
  @override
  PlayerCardEntity get card;
  @override
  String get position;
  @override
  int get slotIndex;

  /// Create a copy of SquadItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SquadItemEntityImplCopyWith<_$SquadItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
