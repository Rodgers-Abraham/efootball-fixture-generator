// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GoalEventModel _$GoalEventModelFromJson(Map<String, dynamic> json) {
  return _GoalEventModel.fromJson(json);
}

/// @nodoc
mixin _$GoalEventModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_id')
  String get matchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'squad_item_id')
  String get squadItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Joined from squad_items -> player_cards -> users
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get playerName => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get teamTag => throw _privateConstructorUsedError;

  /// Serializes this GoalEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalEventModelCopyWith<GoalEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalEventModelCopyWith<$Res> {
  factory $GoalEventModelCopyWith(
    GoalEventModel value,
    $Res Function(GoalEventModel) then,
  ) = _$GoalEventModelCopyWithImpl<$Res, GoalEventModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'match_id') String matchId,
    @JsonKey(name: 'squad_item_id') String squadItemId,
    @JsonKey(name: 'event_type') String eventType,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String playerName,
    @JsonKey(includeFromJson: false, includeToJson: false) String teamTag,
  });
}

/// @nodoc
class _$GoalEventModelCopyWithImpl<$Res, $Val extends GoalEventModel>
    implements $GoalEventModelCopyWith<$Res> {
  _$GoalEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? squadItemId = null,
    Object? eventType = null,
    Object? createdAt = freezed,
    Object? playerName = null,
    Object? teamTag = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            squadItemId: null == squadItemId
                ? _value.squadItemId
                : squadItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            teamTag: null == teamTag
                ? _value.teamTag
                : teamTag // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoalEventModelImplCopyWith<$Res>
    implements $GoalEventModelCopyWith<$Res> {
  factory _$$GoalEventModelImplCopyWith(
    _$GoalEventModelImpl value,
    $Res Function(_$GoalEventModelImpl) then,
  ) = __$$GoalEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'match_id') String matchId,
    @JsonKey(name: 'squad_item_id') String squadItemId,
    @JsonKey(name: 'event_type') String eventType,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String playerName,
    @JsonKey(includeFromJson: false, includeToJson: false) String teamTag,
  });
}

/// @nodoc
class __$$GoalEventModelImplCopyWithImpl<$Res>
    extends _$GoalEventModelCopyWithImpl<$Res, _$GoalEventModelImpl>
    implements _$$GoalEventModelImplCopyWith<$Res> {
  __$$GoalEventModelImplCopyWithImpl(
    _$GoalEventModelImpl _value,
    $Res Function(_$GoalEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoalEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? squadItemId = null,
    Object? eventType = null,
    Object? createdAt = freezed,
    Object? playerName = null,
    Object? teamTag = null,
  }) {
    return _then(
      _$GoalEventModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        squadItemId: null == squadItemId
            ? _value.squadItemId
            : squadItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        teamTag: null == teamTag
            ? _value.teamTag
            : teamTag // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalEventModelImpl extends _GoalEventModel {
  const _$GoalEventModelImpl({
    required this.id,
    @JsonKey(name: 'match_id') required this.matchId,
    @JsonKey(name: 'squad_item_id') required this.squadItemId,
    @JsonKey(name: 'event_type') required this.eventType,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.playerName = '',
    @JsonKey(includeFromJson: false, includeToJson: false) this.teamTag = '',
  }) : super._();

  factory _$GoalEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalEventModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'match_id')
  final String matchId;
  @override
  @JsonKey(name: 'squad_item_id')
  final String squadItemId;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Joined from squad_items -> player_cards -> users
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String playerName;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String teamTag;

  @override
  String toString() {
    return 'GoalEventModel(id: $id, matchId: $matchId, squadItemId: $squadItemId, eventType: $eventType, createdAt: $createdAt, playerName: $playerName, teamTag: $teamTag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.squadItemId, squadItemId) ||
                other.squadItemId == squadItemId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.teamTag, teamTag) || other.teamTag == teamTag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    matchId,
    squadItemId,
    eventType,
    createdAt,
    playerName,
    teamTag,
  );

  /// Create a copy of GoalEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalEventModelImplCopyWith<_$GoalEventModelImpl> get copyWith =>
      __$$GoalEventModelImplCopyWithImpl<_$GoalEventModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalEventModelImplToJson(this);
  }
}

abstract class _GoalEventModel extends GoalEventModel {
  const factory _GoalEventModel({
    required final String id,
    @JsonKey(name: 'match_id') required final String matchId,
    @JsonKey(name: 'squad_item_id') required final String squadItemId,
    @JsonKey(name: 'event_type') required final String eventType,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String playerName,
    @JsonKey(includeFromJson: false, includeToJson: false) final String teamTag,
  }) = _$GoalEventModelImpl;
  const _GoalEventModel._() : super._();

  factory _GoalEventModel.fromJson(Map<String, dynamic> json) =
      _$GoalEventModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'match_id')
  String get matchId;
  @override
  @JsonKey(name: 'squad_item_id')
  String get squadItemId;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Joined from squad_items -> player_cards -> users
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get playerName;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get teamTag;

  /// Create a copy of GoalEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalEventModelImplCopyWith<_$GoalEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
