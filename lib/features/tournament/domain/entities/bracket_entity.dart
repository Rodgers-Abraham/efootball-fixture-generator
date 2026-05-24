import 'package:freezed_annotation/freezed_annotation.dart';
import 'match_entity.dart';

part 'bracket_entity.freezed.dart';

@freezed
class BracketEntity with _$BracketEntity {
  const factory BracketEntity({
    required String tournamentId,
    required String format,
    required List<List<MatchEntity>> rounds,
  }) = _BracketEntity;

  const BracketEntity._();

  int get totalRounds => rounds.length;
  int get totalMatches => rounds.fold(0, (sum, r) => sum + r.length);

  List<MatchEntity> get allMatches =>
      rounds.expand((r) => r).toList();
}
