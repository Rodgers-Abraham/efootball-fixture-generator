// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TournamentEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of TournamentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentEntityCopyWith<TournamentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentEntityCopyWith<$Res> {
  factory $TournamentEntityCopyWith(
    TournamentEntity value,
    $Res Function(TournamentEntity) then,
  ) = _$TournamentEntityCopyWithImpl<$Res, TournamentEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    String format,
    String status,
    String? createdBy,
    String? inviteCode,
    List<String> participantIds,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$TournamentEntityCopyWithImpl<$Res, $Val extends TournamentEntity>
    implements $TournamentEntityCopyWith<$Res> {
  _$TournamentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? format = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? inviteCode = freezed,
    Object? participantIds = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            inviteCode: freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            participantIds: null == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$TournamentEntityImplCopyWith<$Res>
    implements $TournamentEntityCopyWith<$Res> {
  factory _$$TournamentEntityImplCopyWith(
    _$TournamentEntityImpl value,
    $Res Function(_$TournamentEntityImpl) then,
  ) = __$$TournamentEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String format,
    String status,
    String? createdBy,
    String? inviteCode,
    List<String> participantIds,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$TournamentEntityImplCopyWithImpl<$Res>
    extends _$TournamentEntityCopyWithImpl<$Res, _$TournamentEntityImpl>
    implements _$$TournamentEntityImplCopyWith<$Res> {
  __$$TournamentEntityImplCopyWithImpl(
    _$TournamentEntityImpl _value,
    $Res Function(_$TournamentEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? format = null,
    Object? status = null,
    Object? createdBy = freezed,
    Object? inviteCode = freezed,
    Object? participantIds = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TournamentEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        inviteCode: freezed == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantIds: null == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$TournamentEntityImpl implements _TournamentEntity {
  const _$TournamentEntityImpl({
    required this.id,
    required this.name,
    required this.format,
    required this.status,
    this.createdBy,
    this.inviteCode,
    final List<String> participantIds = const [],
    this.createdAt,
  }) : _participantIds = participantIds;

  @override
  final String id;
  @override
  final String name;
  @override
  final String format;
  @override
  final String status;
  @override
  final String? createdBy;
  @override
  final String? inviteCode;
  final List<String> _participantIds;
  @override
  @JsonKey()
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TournamentEntity(id: $id, name: $name, format: $format, status: $status, createdBy: $createdBy, inviteCode: $inviteCode, participantIds: $participantIds, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    format,
    status,
    createdBy,
    inviteCode,
    const DeepCollectionEquality().hash(_participantIds),
    createdAt,
  );

  /// Create a copy of TournamentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentEntityImplCopyWith<_$TournamentEntityImpl> get copyWith =>
      __$$TournamentEntityImplCopyWithImpl<_$TournamentEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _TournamentEntity implements TournamentEntity {
  const factory _TournamentEntity({
    required final String id,
    required final String name,
    required final String format,
    required final String status,
    final String? createdBy,
    final String? inviteCode,
    final List<String> participantIds,
    final DateTime? createdAt,
  }) = _$TournamentEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get format;
  @override
  String get status;
  @override
  String? get createdBy;
  @override
  String? get inviteCode;
  @override
  List<String> get participantIds;
  @override
  DateTime? get createdAt;

  /// Create a copy of TournamentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentEntityImplCopyWith<_$TournamentEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
