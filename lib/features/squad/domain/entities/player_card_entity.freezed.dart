// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_card_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlayerCardEntity {
  String get masterCardId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get cardType => throw _privateConstructorUsedError;
  int get maxRating => throw _privateConstructorUsedError;
  String? get cardImageUrl => throw _privateConstructorUsedError;

  /// Create a copy of PlayerCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCardEntityCopyWith<PlayerCardEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCardEntityCopyWith<$Res> {
  factory $PlayerCardEntityCopyWith(
    PlayerCardEntity value,
    $Res Function(PlayerCardEntity) then,
  ) = _$PlayerCardEntityCopyWithImpl<$Res, PlayerCardEntity>;
  @useResult
  $Res call({
    String masterCardId,
    String playerName,
    String cardType,
    int maxRating,
    String? cardImageUrl,
  });
}

/// @nodoc
class _$PlayerCardEntityCopyWithImpl<$Res, $Val extends PlayerCardEntity>
    implements $PlayerCardEntityCopyWith<$Res> {
  _$PlayerCardEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterCardId = null,
    Object? playerName = null,
    Object? cardType = null,
    Object? maxRating = null,
    Object? cardImageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            masterCardId: null == masterCardId
                ? _value.masterCardId
                : masterCardId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            cardType: null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                      as String,
            maxRating: null == maxRating
                ? _value.maxRating
                : maxRating // ignore: cast_nullable_to_non_nullable
                      as int,
            cardImageUrl: freezed == cardImageUrl
                ? _value.cardImageUrl
                : cardImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerCardEntityImplCopyWith<$Res>
    implements $PlayerCardEntityCopyWith<$Res> {
  factory _$$PlayerCardEntityImplCopyWith(
    _$PlayerCardEntityImpl value,
    $Res Function(_$PlayerCardEntityImpl) then,
  ) = __$$PlayerCardEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String masterCardId,
    String playerName,
    String cardType,
    int maxRating,
    String? cardImageUrl,
  });
}

/// @nodoc
class __$$PlayerCardEntityImplCopyWithImpl<$Res>
    extends _$PlayerCardEntityCopyWithImpl<$Res, _$PlayerCardEntityImpl>
    implements _$$PlayerCardEntityImplCopyWith<$Res> {
  __$$PlayerCardEntityImplCopyWithImpl(
    _$PlayerCardEntityImpl _value,
    $Res Function(_$PlayerCardEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterCardId = null,
    Object? playerName = null,
    Object? cardType = null,
    Object? maxRating = null,
    Object? cardImageUrl = freezed,
  }) {
    return _then(
      _$PlayerCardEntityImpl(
        masterCardId: null == masterCardId
            ? _value.masterCardId
            : masterCardId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        cardType: null == cardType
            ? _value.cardType
            : cardType // ignore: cast_nullable_to_non_nullable
                  as String,
        maxRating: null == maxRating
            ? _value.maxRating
            : maxRating // ignore: cast_nullable_to_non_nullable
                  as int,
        cardImageUrl: freezed == cardImageUrl
            ? _value.cardImageUrl
            : cardImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PlayerCardEntityImpl implements _PlayerCardEntity {
  const _$PlayerCardEntityImpl({
    required this.masterCardId,
    required this.playerName,
    required this.cardType,
    required this.maxRating,
    this.cardImageUrl,
  });

  @override
  final String masterCardId;
  @override
  final String playerName;
  @override
  final String cardType;
  @override
  final int maxRating;
  @override
  final String? cardImageUrl;

  @override
  String toString() {
    return 'PlayerCardEntity(masterCardId: $masterCardId, playerName: $playerName, cardType: $cardType, maxRating: $maxRating, cardImageUrl: $cardImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerCardEntityImpl &&
            (identical(other.masterCardId, masterCardId) ||
                other.masterCardId == masterCardId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.maxRating, maxRating) ||
                other.maxRating == maxRating) &&
            (identical(other.cardImageUrl, cardImageUrl) ||
                other.cardImageUrl == cardImageUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    masterCardId,
    playerName,
    cardType,
    maxRating,
    cardImageUrl,
  );

  /// Create a copy of PlayerCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerCardEntityImplCopyWith<_$PlayerCardEntityImpl> get copyWith =>
      __$$PlayerCardEntityImplCopyWithImpl<_$PlayerCardEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerCardEntity implements PlayerCardEntity {
  const factory _PlayerCardEntity({
    required final String masterCardId,
    required final String playerName,
    required final String cardType,
    required final int maxRating,
    final String? cardImageUrl,
  }) = _$PlayerCardEntityImpl;

  @override
  String get masterCardId;
  @override
  String get playerName;
  @override
  String get cardType;
  @override
  int get maxRating;
  @override
  String? get cardImageUrl;

  /// Create a copy of PlayerCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerCardEntityImplCopyWith<_$PlayerCardEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
