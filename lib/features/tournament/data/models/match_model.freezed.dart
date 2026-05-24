// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) {
  return _MatchModel.fromJson(json);
}

/// @nodoc
mixin _$MatchModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tournament_id')
  String get tournamentId => throw _privateConstructorUsedError;
  int get round => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_number')
  int get matchNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_user_id')
  String? get homeUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_user_id')
  String? get awayUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_score')
  int? get homeScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_score')
  int? get awayScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_possession')
  int? get homePossession => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_possession')
  int? get awayPossession => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_shots')
  int? get homeShots => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_shots')
  int? get awayShots => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_shots_on_target')
  int? get homeShotsOnTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_shots_on_target')
  int? get awayShotsOnTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_fouls')
  int? get homeFouls => throw _privateConstructorUsedError;
  @JsonKey(name: 'away_fouls')
  int? get awayFouls => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'played_at')
  DateTime? get playedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Joined fields from users table (not stored in matches table)
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get homeUsername => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get awayUsername => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get homeTeamTag => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get awayTeamTag => throw _privateConstructorUsedError;

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchModelCopyWith<MatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchModelCopyWith<$Res> {
  factory $MatchModelCopyWith(
    MatchModel value,
    $Res Function(MatchModel) then,
  ) = _$MatchModelCopyWithImpl<$Res, MatchModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tournament_id') String tournamentId,
    int round,
    @JsonKey(name: 'match_number') int matchNumber,
    @JsonKey(name: 'home_user_id') String? homeUserId,
    @JsonKey(name: 'away_user_id') String? awayUserId,
    @JsonKey(name: 'home_score') int? homeScore,
    @JsonKey(name: 'away_score') int? awayScore,
    @JsonKey(name: 'home_possession') int? homePossession,
    @JsonKey(name: 'away_possession') int? awayPossession,
    @JsonKey(name: 'home_shots') int? homeShots,
    @JsonKey(name: 'away_shots') int? awayShots,
    @JsonKey(name: 'home_shots_on_target') int? homeShotsOnTarget,
    @JsonKey(name: 'away_shots_on_target') int? awayShotsOnTarget,
    @JsonKey(name: 'home_fouls') int? homeFouls,
    @JsonKey(name: 'away_fouls') int? awayFouls,
    String status,
    @JsonKey(name: 'played_at') DateTime? playedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeTeamTag,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayTeamTag,
  });
}

/// @nodoc
class _$MatchModelCopyWithImpl<$Res, $Val extends MatchModel>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? round = null,
    Object? matchNumber = null,
    Object? homeUserId = freezed,
    Object? awayUserId = freezed,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? homePossession = freezed,
    Object? awayPossession = freezed,
    Object? homeShots = freezed,
    Object? awayShots = freezed,
    Object? homeShotsOnTarget = freezed,
    Object? awayShotsOnTarget = freezed,
    Object? homeFouls = freezed,
    Object? awayFouls = freezed,
    Object? status = null,
    Object? playedAt = freezed,
    Object? createdAt = freezed,
    Object? homeUsername = freezed,
    Object? awayUsername = freezed,
    Object? homeTeamTag = freezed,
    Object? awayTeamTag = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tournamentId: null == tournamentId
                ? _value.tournamentId
                : tournamentId // ignore: cast_nullable_to_non_nullable
                      as String,
            round: null == round
                ? _value.round
                : round // ignore: cast_nullable_to_non_nullable
                      as int,
            matchNumber: null == matchNumber
                ? _value.matchNumber
                : matchNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            homeUserId: freezed == homeUserId
                ? _value.homeUserId
                : homeUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            awayUserId: freezed == awayUserId
                ? _value.awayUserId
                : awayUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            homeScore: freezed == homeScore
                ? _value.homeScore
                : homeScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            awayScore: freezed == awayScore
                ? _value.awayScore
                : awayScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            homePossession: freezed == homePossession
                ? _value.homePossession
                : homePossession // ignore: cast_nullable_to_non_nullable
                      as int?,
            awayPossession: freezed == awayPossession
                ? _value.awayPossession
                : awayPossession // ignore: cast_nullable_to_non_nullable
                      as int?,
            homeShots: freezed == homeShots
                ? _value.homeShots
                : homeShots // ignore: cast_nullable_to_non_nullable
                      as int?,
            awayShots: freezed == awayShots
                ? _value.awayShots
                : awayShots // ignore: cast_nullable_to_non_nullable
                      as int?,
            homeShotsOnTarget: freezed == homeShotsOnTarget
                ? _value.homeShotsOnTarget
                : homeShotsOnTarget // ignore: cast_nullable_to_non_nullable
                      as int?,
            awayShotsOnTarget: freezed == awayShotsOnTarget
                ? _value.awayShotsOnTarget
                : awayShotsOnTarget // ignore: cast_nullable_to_non_nullable
                      as int?,
            homeFouls: freezed == homeFouls
                ? _value.homeFouls
                : homeFouls // ignore: cast_nullable_to_non_nullable
                      as int?,
            awayFouls: freezed == awayFouls
                ? _value.awayFouls
                : awayFouls // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            playedAt: freezed == playedAt
                ? _value.playedAt
                : playedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            homeUsername: freezed == homeUsername
                ? _value.homeUsername
                : homeUsername // ignore: cast_nullable_to_non_nullable
                      as String?,
            awayUsername: freezed == awayUsername
                ? _value.awayUsername
                : awayUsername // ignore: cast_nullable_to_non_nullable
                      as String?,
            homeTeamTag: freezed == homeTeamTag
                ? _value.homeTeamTag
                : homeTeamTag // ignore: cast_nullable_to_non_nullable
                      as String?,
            awayTeamTag: freezed == awayTeamTag
                ? _value.awayTeamTag
                : awayTeamTag // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchModelImplCopyWith<$Res>
    implements $MatchModelCopyWith<$Res> {
  factory _$$MatchModelImplCopyWith(
    _$MatchModelImpl value,
    $Res Function(_$MatchModelImpl) then,
  ) = __$$MatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tournament_id') String tournamentId,
    int round,
    @JsonKey(name: 'match_number') int matchNumber,
    @JsonKey(name: 'home_user_id') String? homeUserId,
    @JsonKey(name: 'away_user_id') String? awayUserId,
    @JsonKey(name: 'home_score') int? homeScore,
    @JsonKey(name: 'away_score') int? awayScore,
    @JsonKey(name: 'home_possession') int? homePossession,
    @JsonKey(name: 'away_possession') int? awayPossession,
    @JsonKey(name: 'home_shots') int? homeShots,
    @JsonKey(name: 'away_shots') int? awayShots,
    @JsonKey(name: 'home_shots_on_target') int? homeShotsOnTarget,
    @JsonKey(name: 'away_shots_on_target') int? awayShotsOnTarget,
    @JsonKey(name: 'home_fouls') int? homeFouls,
    @JsonKey(name: 'away_fouls') int? awayFouls,
    String status,
    @JsonKey(name: 'played_at') DateTime? playedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeTeamTag,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayTeamTag,
  });
}

/// @nodoc
class __$$MatchModelImplCopyWithImpl<$Res>
    extends _$MatchModelCopyWithImpl<$Res, _$MatchModelImpl>
    implements _$$MatchModelImplCopyWith<$Res> {
  __$$MatchModelImplCopyWithImpl(
    _$MatchModelImpl _value,
    $Res Function(_$MatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? round = null,
    Object? matchNumber = null,
    Object? homeUserId = freezed,
    Object? awayUserId = freezed,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? homePossession = freezed,
    Object? awayPossession = freezed,
    Object? homeShots = freezed,
    Object? awayShots = freezed,
    Object? homeShotsOnTarget = freezed,
    Object? awayShotsOnTarget = freezed,
    Object? homeFouls = freezed,
    Object? awayFouls = freezed,
    Object? status = null,
    Object? playedAt = freezed,
    Object? createdAt = freezed,
    Object? homeUsername = freezed,
    Object? awayUsername = freezed,
    Object? homeTeamTag = freezed,
    Object? awayTeamTag = freezed,
  }) {
    return _then(
      _$MatchModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tournamentId: null == tournamentId
            ? _value.tournamentId
            : tournamentId // ignore: cast_nullable_to_non_nullable
                  as String,
        round: null == round
            ? _value.round
            : round // ignore: cast_nullable_to_non_nullable
                  as int,
        matchNumber: null == matchNumber
            ? _value.matchNumber
            : matchNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        homeUserId: freezed == homeUserId
            ? _value.homeUserId
            : homeUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        awayUserId: freezed == awayUserId
            ? _value.awayUserId
            : awayUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        homeScore: freezed == homeScore
            ? _value.homeScore
            : homeScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        awayScore: freezed == awayScore
            ? _value.awayScore
            : awayScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        homePossession: freezed == homePossession
            ? _value.homePossession
            : homePossession // ignore: cast_nullable_to_non_nullable
                  as int?,
        awayPossession: freezed == awayPossession
            ? _value.awayPossession
            : awayPossession // ignore: cast_nullable_to_non_nullable
                  as int?,
        homeShots: freezed == homeShots
            ? _value.homeShots
            : homeShots // ignore: cast_nullable_to_non_nullable
                  as int?,
        awayShots: freezed == awayShots
            ? _value.awayShots
            : awayShots // ignore: cast_nullable_to_non_nullable
                  as int?,
        homeShotsOnTarget: freezed == homeShotsOnTarget
            ? _value.homeShotsOnTarget
            : homeShotsOnTarget // ignore: cast_nullable_to_non_nullable
                  as int?,
        awayShotsOnTarget: freezed == awayShotsOnTarget
            ? _value.awayShotsOnTarget
            : awayShotsOnTarget // ignore: cast_nullable_to_non_nullable
                  as int?,
        homeFouls: freezed == homeFouls
            ? _value.homeFouls
            : homeFouls // ignore: cast_nullable_to_non_nullable
                  as int?,
        awayFouls: freezed == awayFouls
            ? _value.awayFouls
            : awayFouls // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        playedAt: freezed == playedAt
            ? _value.playedAt
            : playedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        homeUsername: freezed == homeUsername
            ? _value.homeUsername
            : homeUsername // ignore: cast_nullable_to_non_nullable
                  as String?,
        awayUsername: freezed == awayUsername
            ? _value.awayUsername
            : awayUsername // ignore: cast_nullable_to_non_nullable
                  as String?,
        homeTeamTag: freezed == homeTeamTag
            ? _value.homeTeamTag
            : homeTeamTag // ignore: cast_nullable_to_non_nullable
                  as String?,
        awayTeamTag: freezed == awayTeamTag
            ? _value.awayTeamTag
            : awayTeamTag // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchModelImpl extends _MatchModel {
  const _$MatchModelImpl({
    required this.id,
    @JsonKey(name: 'tournament_id') required this.tournamentId,
    required this.round,
    @JsonKey(name: 'match_number') required this.matchNumber,
    @JsonKey(name: 'home_user_id') this.homeUserId,
    @JsonKey(name: 'away_user_id') this.awayUserId,
    @JsonKey(name: 'home_score') this.homeScore,
    @JsonKey(name: 'away_score') this.awayScore,
    @JsonKey(name: 'home_possession') this.homePossession,
    @JsonKey(name: 'away_possession') this.awayPossession,
    @JsonKey(name: 'home_shots') this.homeShots,
    @JsonKey(name: 'away_shots') this.awayShots,
    @JsonKey(name: 'home_shots_on_target') this.homeShotsOnTarget,
    @JsonKey(name: 'away_shots_on_target') this.awayShotsOnTarget,
    @JsonKey(name: 'home_fouls') this.homeFouls,
    @JsonKey(name: 'away_fouls') this.awayFouls,
    this.status = 'scheduled',
    @JsonKey(name: 'played_at') this.playedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.homeUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) this.awayUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) this.homeTeamTag,
    @JsonKey(includeFromJson: false, includeToJson: false) this.awayTeamTag,
  }) : super._();

  factory _$MatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tournament_id')
  final String tournamentId;
  @override
  final int round;
  @override
  @JsonKey(name: 'match_number')
  final int matchNumber;
  @override
  @JsonKey(name: 'home_user_id')
  final String? homeUserId;
  @override
  @JsonKey(name: 'away_user_id')
  final String? awayUserId;
  @override
  @JsonKey(name: 'home_score')
  final int? homeScore;
  @override
  @JsonKey(name: 'away_score')
  final int? awayScore;
  @override
  @JsonKey(name: 'home_possession')
  final int? homePossession;
  @override
  @JsonKey(name: 'away_possession')
  final int? awayPossession;
  @override
  @JsonKey(name: 'home_shots')
  final int? homeShots;
  @override
  @JsonKey(name: 'away_shots')
  final int? awayShots;
  @override
  @JsonKey(name: 'home_shots_on_target')
  final int? homeShotsOnTarget;
  @override
  @JsonKey(name: 'away_shots_on_target')
  final int? awayShotsOnTarget;
  @override
  @JsonKey(name: 'home_fouls')
  final int? homeFouls;
  @override
  @JsonKey(name: 'away_fouls')
  final int? awayFouls;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'played_at')
  final DateTime? playedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Joined fields from users table (not stored in matches table)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? homeUsername;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? awayUsername;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? homeTeamTag;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? awayTeamTag;

  @override
  String toString() {
    return 'MatchModel(id: $id, tournamentId: $tournamentId, round: $round, matchNumber: $matchNumber, homeUserId: $homeUserId, awayUserId: $awayUserId, homeScore: $homeScore, awayScore: $awayScore, homePossession: $homePossession, awayPossession: $awayPossession, homeShots: $homeShots, awayShots: $awayShots, homeShotsOnTarget: $homeShotsOnTarget, awayShotsOnTarget: $awayShotsOnTarget, homeFouls: $homeFouls, awayFouls: $awayFouls, status: $status, playedAt: $playedAt, createdAt: $createdAt, homeUsername: $homeUsername, awayUsername: $awayUsername, homeTeamTag: $homeTeamTag, awayTeamTag: $awayTeamTag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.matchNumber, matchNumber) ||
                other.matchNumber == matchNumber) &&
            (identical(other.homeUserId, homeUserId) ||
                other.homeUserId == homeUserId) &&
            (identical(other.awayUserId, awayUserId) ||
                other.awayUserId == awayUserId) &&
            (identical(other.homeScore, homeScore) ||
                other.homeScore == homeScore) &&
            (identical(other.awayScore, awayScore) ||
                other.awayScore == awayScore) &&
            (identical(other.homePossession, homePossession) ||
                other.homePossession == homePossession) &&
            (identical(other.awayPossession, awayPossession) ||
                other.awayPossession == awayPossession) &&
            (identical(other.homeShots, homeShots) ||
                other.homeShots == homeShots) &&
            (identical(other.awayShots, awayShots) ||
                other.awayShots == awayShots) &&
            (identical(other.homeShotsOnTarget, homeShotsOnTarget) ||
                other.homeShotsOnTarget == homeShotsOnTarget) &&
            (identical(other.awayShotsOnTarget, awayShotsOnTarget) ||
                other.awayShotsOnTarget == awayShotsOnTarget) &&
            (identical(other.homeFouls, homeFouls) ||
                other.homeFouls == homeFouls) &&
            (identical(other.awayFouls, awayFouls) ||
                other.awayFouls == awayFouls) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.homeUsername, homeUsername) ||
                other.homeUsername == homeUsername) &&
            (identical(other.awayUsername, awayUsername) ||
                other.awayUsername == awayUsername) &&
            (identical(other.homeTeamTag, homeTeamTag) ||
                other.homeTeamTag == homeTeamTag) &&
            (identical(other.awayTeamTag, awayTeamTag) ||
                other.awayTeamTag == awayTeamTag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    tournamentId,
    round,
    matchNumber,
    homeUserId,
    awayUserId,
    homeScore,
    awayScore,
    homePossession,
    awayPossession,
    homeShots,
    awayShots,
    homeShotsOnTarget,
    awayShotsOnTarget,
    homeFouls,
    awayFouls,
    status,
    playedAt,
    createdAt,
    homeUsername,
    awayUsername,
    homeTeamTag,
    awayTeamTag,
  ]);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      __$$MatchModelImplCopyWithImpl<_$MatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchModelImplToJson(this);
  }
}

abstract class _MatchModel extends MatchModel {
  const factory _MatchModel({
    required final String id,
    @JsonKey(name: 'tournament_id') required final String tournamentId,
    required final int round,
    @JsonKey(name: 'match_number') required final int matchNumber,
    @JsonKey(name: 'home_user_id') final String? homeUserId,
    @JsonKey(name: 'away_user_id') final String? awayUserId,
    @JsonKey(name: 'home_score') final int? homeScore,
    @JsonKey(name: 'away_score') final int? awayScore,
    @JsonKey(name: 'home_possession') final int? homePossession,
    @JsonKey(name: 'away_possession') final int? awayPossession,
    @JsonKey(name: 'home_shots') final int? homeShots,
    @JsonKey(name: 'away_shots') final int? awayShots,
    @JsonKey(name: 'home_shots_on_target') final int? homeShotsOnTarget,
    @JsonKey(name: 'away_shots_on_target') final int? awayShotsOnTarget,
    @JsonKey(name: 'home_fouls') final int? homeFouls,
    @JsonKey(name: 'away_fouls') final int? awayFouls,
    final String status,
    @JsonKey(name: 'played_at') final DateTime? playedAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String? homeUsername,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String? awayUsername,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String? homeTeamTag,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String? awayTeamTag,
  }) = _$MatchModelImpl;
  const _MatchModel._() : super._();

  factory _MatchModel.fromJson(Map<String, dynamic> json) =
      _$MatchModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tournament_id')
  String get tournamentId;
  @override
  int get round;
  @override
  @JsonKey(name: 'match_number')
  int get matchNumber;
  @override
  @JsonKey(name: 'home_user_id')
  String? get homeUserId;
  @override
  @JsonKey(name: 'away_user_id')
  String? get awayUserId;
  @override
  @JsonKey(name: 'home_score')
  int? get homeScore;
  @override
  @JsonKey(name: 'away_score')
  int? get awayScore;
  @override
  @JsonKey(name: 'home_possession')
  int? get homePossession;
  @override
  @JsonKey(name: 'away_possession')
  int? get awayPossession;
  @override
  @JsonKey(name: 'home_shots')
  int? get homeShots;
  @override
  @JsonKey(name: 'away_shots')
  int? get awayShots;
  @override
  @JsonKey(name: 'home_shots_on_target')
  int? get homeShotsOnTarget;
  @override
  @JsonKey(name: 'away_shots_on_target')
  int? get awayShotsOnTarget;
  @override
  @JsonKey(name: 'home_fouls')
  int? get homeFouls;
  @override
  @JsonKey(name: 'away_fouls')
  int? get awayFouls;
  @override
  String get status;
  @override
  @JsonKey(name: 'played_at')
  DateTime? get playedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Joined fields from users table (not stored in matches table)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get homeUsername;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get awayUsername;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get homeTeamTag;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get awayTeamTag;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
