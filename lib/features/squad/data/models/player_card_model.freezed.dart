// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerCardModel _$PlayerCardModelFromJson(Map<String, dynamic> json) {
  return _PlayerCardModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerCardModel {
  @JsonKey(name: 'master_card_id')
  String get masterCardId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_type')
  String get cardType => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_rating')
  int get maxRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'card_image_url')
  String? get cardImageUrl => throw _privateConstructorUsedError;

  /// Serializes this PlayerCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCardModelCopyWith<PlayerCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCardModelCopyWith<$Res> {
  factory $PlayerCardModelCopyWith(
    PlayerCardModel value,
    $Res Function(PlayerCardModel) then,
  ) = _$PlayerCardModelCopyWithImpl<$Res, PlayerCardModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'master_card_id') String masterCardId,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'card_type') String cardType,
    @JsonKey(name: 'max_rating') int maxRating,
    @JsonKey(name: 'card_image_url') String? cardImageUrl,
  });
}

/// @nodoc
class _$PlayerCardModelCopyWithImpl<$Res, $Val extends PlayerCardModel>
    implements $PlayerCardModelCopyWith<$Res> {
  _$PlayerCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerCardModel
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
abstract class _$$PlayerCardModelImplCopyWith<$Res>
    implements $PlayerCardModelCopyWith<$Res> {
  factory _$$PlayerCardModelImplCopyWith(
    _$PlayerCardModelImpl value,
    $Res Function(_$PlayerCardModelImpl) then,
  ) = __$$PlayerCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'master_card_id') String masterCardId,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'card_type') String cardType,
    @JsonKey(name: 'max_rating') int maxRating,
    @JsonKey(name: 'card_image_url') String? cardImageUrl,
  });
}

/// @nodoc
class __$$PlayerCardModelImplCopyWithImpl<$Res>
    extends _$PlayerCardModelCopyWithImpl<$Res, _$PlayerCardModelImpl>
    implements _$$PlayerCardModelImplCopyWith<$Res> {
  __$$PlayerCardModelImplCopyWithImpl(
    _$PlayerCardModelImpl _value,
    $Res Function(_$PlayerCardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerCardModel
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
      _$PlayerCardModelImpl(
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
@JsonSerializable()
class _$PlayerCardModelImpl extends _PlayerCardModel {
  const _$PlayerCardModelImpl({
    @JsonKey(name: 'master_card_id') required this.masterCardId,
    @JsonKey(name: 'player_name') required this.playerName,
    @JsonKey(name: 'card_type') required this.cardType,
    @JsonKey(name: 'max_rating') required this.maxRating,
    @JsonKey(name: 'card_image_url') this.cardImageUrl,
  }) : super._();

  factory _$PlayerCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerCardModelImplFromJson(json);

  @override
  @JsonKey(name: 'master_card_id')
  final String masterCardId;
  @override
  @JsonKey(name: 'player_name')
  final String playerName;
  @override
  @JsonKey(name: 'card_type')
  final String cardType;
  @override
  @JsonKey(name: 'max_rating')
  final int maxRating;
  @override
  @JsonKey(name: 'card_image_url')
  final String? cardImageUrl;

  @override
  String toString() {
    return 'PlayerCardModel(masterCardId: $masterCardId, playerName: $playerName, cardType: $cardType, maxRating: $maxRating, cardImageUrl: $cardImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerCardModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    masterCardId,
    playerName,
    cardType,
    maxRating,
    cardImageUrl,
  );

  /// Create a copy of PlayerCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerCardModelImplCopyWith<_$PlayerCardModelImpl> get copyWith =>
      __$$PlayerCardModelImplCopyWithImpl<_$PlayerCardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerCardModelImplToJson(this);
  }
}

abstract class _PlayerCardModel extends PlayerCardModel {
  const factory _PlayerCardModel({
    @JsonKey(name: 'master_card_id') required final String masterCardId,
    @JsonKey(name: 'player_name') required final String playerName,
    @JsonKey(name: 'card_type') required final String cardType,
    @JsonKey(name: 'max_rating') required final int maxRating,
    @JsonKey(name: 'card_image_url') final String? cardImageUrl,
  }) = _$PlayerCardModelImpl;
  const _PlayerCardModel._() : super._();

  factory _PlayerCardModel.fromJson(Map<String, dynamic> json) =
      _$PlayerCardModelImpl.fromJson;

  @override
  @JsonKey(name: 'master_card_id')
  String get masterCardId;
  @override
  @JsonKey(name: 'player_name')
  String get playerName;
  @override
  @JsonKey(name: 'card_type')
  String get cardType;
  @override
  @JsonKey(name: 'max_rating')
  int get maxRating;
  @override
  @JsonKey(name: 'card_image_url')
  String? get cardImageUrl;

  /// Create a copy of PlayerCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerCardModelImplCopyWith<_$PlayerCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
