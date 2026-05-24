// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_event_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GoalEventEntity {
  String get id => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get squadItemId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get teamTag => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of GoalEventEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalEventEntityCopyWith<GoalEventEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalEventEntityCopyWith<$Res> {
  factory $GoalEventEntityCopyWith(
    GoalEventEntity value,
    $Res Function(GoalEventEntity) then,
  ) = _$GoalEventEntityCopyWithImpl<$Res, GoalEventEntity>;
  @useResult
  $Res call({
    String id,
    String matchId,
    String squadItemId,
    String playerName,
    String teamTag,
    String eventType,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$GoalEventEntityCopyWithImpl<$Res, $Val extends GoalEventEntity>
    implements $GoalEventEntityCopyWith<$Res> {
  _$GoalEventEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalEventEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? squadItemId = null,
    Object? playerName = null,
    Object? teamTag = null,
    Object? eventType = null,
    Object? createdAt = freezed,
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
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            teamTag: null == teamTag
                ? _value.teamTag
                : teamTag // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoalEventEntityImplCopyWith<$Res>
    implements $GoalEventEntityCopyWith<$Res> {
  factory _$$GoalEventEntityImplCopyWith(
    _$GoalEventEntityImpl value,
    $Res Function(_$GoalEventEntityImpl) then,
  ) = __$$GoalEventEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String matchId,
    String squadItemId,
    String playerName,
    String teamTag,
    String eventType,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$GoalEventEntityImplCopyWithImpl<$Res>
    extends _$GoalEventEntityCopyWithImpl<$Res, _$GoalEventEntityImpl>
    implements _$$GoalEventEntityImplCopyWith<$Res> {
  __$$GoalEventEntityImplCopyWithImpl(
    _$GoalEventEntityImpl _value,
    $Res Function(_$GoalEventEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoalEventEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? squadItemId = null,
    Object? playerName = null,
    Object? teamTag = null,
    Object? eventType = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GoalEventEntityImpl(
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
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        teamTag: null == teamTag
            ? _value.teamTag
            : teamTag // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$GoalEventEntityImpl implements _GoalEventEntity {
  const _$GoalEventEntityImpl({
    required this.id,
    required this.matchId,
    required this.squadItemId,
    required this.playerName,
    required this.teamTag,
    required this.eventType,
    this.createdAt,
  });

  @override
  final String id;
  @override
  final String matchId;
  @override
  final String squadItemId;
  @override
  final String playerName;
  @override
  final String teamTag;
  @override
  final String eventType;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GoalEventEntity(id: $id, matchId: $matchId, squadItemId: $squadItemId, playerName: $playerName, teamTag: $teamTag, eventType: $eventType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalEventEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.squadItemId, squadItemId) ||
                other.squadItemId == squadItemId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.teamTag, teamTag) || other.teamTag == teamTag) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    matchId,
    squadItemId,
    playerName,
    teamTag,
    eventType,
    createdAt,
  );

  /// Create a copy of GoalEventEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalEventEntityImplCopyWith<_$GoalEventEntityImpl> get copyWith =>
      __$$GoalEventEntityImplCopyWithImpl<_$GoalEventEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _GoalEventEntity implements GoalEventEntity {
  const factory _GoalEventEntity({
    required final String id,
    required final String matchId,
    required final String squadItemId,
    required final String playerName,
    required final String teamTag,
    required final String eventType,
    final DateTime? createdAt,
  }) = _$GoalEventEntityImpl;

  @override
  String get id;
  @override
  String get matchId;
  @override
  String get squadItemId;
  @override
  String get playerName;
  @override
  String get teamTag;
  @override
  String get eventType;
  @override
  DateTime? get createdAt;

  /// Create a copy of GoalEventEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalEventEntityImplCopyWith<_$GoalEventEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
