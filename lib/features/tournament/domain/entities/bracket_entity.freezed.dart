// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bracket_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BracketEntity {
  String get tournamentId => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  List<List<MatchEntity>> get rounds => throw _privateConstructorUsedError;

  /// Create a copy of BracketEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BracketEntityCopyWith<BracketEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BracketEntityCopyWith<$Res> {
  factory $BracketEntityCopyWith(
    BracketEntity value,
    $Res Function(BracketEntity) then,
  ) = _$BracketEntityCopyWithImpl<$Res, BracketEntity>;
  @useResult
  $Res call({
    String tournamentId,
    String format,
    List<List<MatchEntity>> rounds,
  });
}

/// @nodoc
class _$BracketEntityCopyWithImpl<$Res, $Val extends BracketEntity>
    implements $BracketEntityCopyWith<$Res> {
  _$BracketEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BracketEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tournamentId = null,
    Object? format = null,
    Object? rounds = null,
  }) {
    return _then(
      _value.copyWith(
            tournamentId: null == tournamentId
                ? _value.tournamentId
                : tournamentId // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as String,
            rounds: null == rounds
                ? _value.rounds
                : rounds // ignore: cast_nullable_to_non_nullable
                      as List<List<MatchEntity>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BracketEntityImplCopyWith<$Res>
    implements $BracketEntityCopyWith<$Res> {
  factory _$$BracketEntityImplCopyWith(
    _$BracketEntityImpl value,
    $Res Function(_$BracketEntityImpl) then,
  ) = __$$BracketEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tournamentId,
    String format,
    List<List<MatchEntity>> rounds,
  });
}

/// @nodoc
class __$$BracketEntityImplCopyWithImpl<$Res>
    extends _$BracketEntityCopyWithImpl<$Res, _$BracketEntityImpl>
    implements _$$BracketEntityImplCopyWith<$Res> {
  __$$BracketEntityImplCopyWithImpl(
    _$BracketEntityImpl _value,
    $Res Function(_$BracketEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BracketEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tournamentId = null,
    Object? format = null,
    Object? rounds = null,
  }) {
    return _then(
      _$BracketEntityImpl(
        tournamentId: null == tournamentId
            ? _value.tournamentId
            : tournamentId // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as String,
        rounds: null == rounds
            ? _value._rounds
            : rounds // ignore: cast_nullable_to_non_nullable
                  as List<List<MatchEntity>>,
      ),
    );
  }
}

/// @nodoc

class _$BracketEntityImpl extends _BracketEntity {
  const _$BracketEntityImpl({
    required this.tournamentId,
    required this.format,
    required final List<List<MatchEntity>> rounds,
  }) : _rounds = rounds,
       super._();

  @override
  final String tournamentId;
  @override
  final String format;
  final List<List<MatchEntity>> _rounds;
  @override
  List<List<MatchEntity>> get rounds {
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rounds);
  }

  @override
  String toString() {
    return 'BracketEntity(tournamentId: $tournamentId, format: $format, rounds: $rounds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BracketEntityImpl &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.format, format) || other.format == format) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    tournamentId,
    format,
    const DeepCollectionEquality().hash(_rounds),
  );

  /// Create a copy of BracketEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BracketEntityImplCopyWith<_$BracketEntityImpl> get copyWith =>
      __$$BracketEntityImplCopyWithImpl<_$BracketEntityImpl>(this, _$identity);
}

abstract class _BracketEntity extends BracketEntity {
  const factory _BracketEntity({
    required final String tournamentId,
    required final String format,
    required final List<List<MatchEntity>> rounds,
  }) = _$BracketEntityImpl;
  const _BracketEntity._() : super._();

  @override
  String get tournamentId;
  @override
  String get format;
  @override
  List<List<MatchEntity>> get rounds;

  /// Create a copy of BracketEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BracketEntityImplCopyWith<_$BracketEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
