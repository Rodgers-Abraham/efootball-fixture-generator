abstract final class AppConstants {
  // ── Supabase table names ───────────────────────────────────────
  static const String usersTable = 'users';
  static const String playerCardsTable = 'player_cards';
  static const String tournamentsTable = 'tournaments';
  static const String tournamentParticipantsTable = 'tournament_participants';
  static const String squadItemsTable = 'squad_items';
  static const String matchesTable = 'matches';
  static const String matchEventsTable = 'match_events';

  // ── Route paths ───────────────────────────────────────────────
  static const String routeRoot = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home/tournaments';
  static const String routeSquad = '/home/squad';
  static const String routeTournamentList = '/home/tournaments';
  static const String routeTournamentCreate = '/tournament/create';
  static const String routeTournamentDetail = '/tournament/:id';
  static const String routeMatchScan = '/tournament/:id/match/:matchId/scan';
  static const String routeMatchQuickTap = '/tournament/:id/match/:matchId/quick-tap';
  static const String routeAnalytics = '/home/analytics';
  static const String routeStandings = '/tournament/:id/standings';
  static const String routeProfile = '/home/profile';

  // ── Timing constants ──────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration splashDuration = Duration(seconds: 2);

  // ── Squad limits ──────────────────────────────────────────────
  static const int maxStarters = 11;
  static const int maxSubstitutes = 12;
  static const int totalSquadSlots = 23;

  // ── OCR thresholds ────────────────────────────────────────────
  static const double ocrMinConfidence = 0.75;
  static const int ocrTotalFields = 9;

  // ── Pagination ────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int searchDebounceMs = 400;

  // ── App info ─────────────────────────────────────────────────
  static const String appName = 'eFootball Fixture Generator';
  static const String appVersion = '1.0.0';

  // ── Tournament formats ────────────────────────────────────────
  static const String formatSingleElimination = 'single_elimination';
  static const String formatDoubleElimination = 'double_elimination';
  static const String formatRoundRobin = 'round_robin';

  // ── Match status ──────────────────────────────────────────────
  static const String matchScheduled = 'scheduled';
  static const String matchInProgress = 'in_progress';
  static const String matchCompleted = 'completed';

  // ── Event types ───────────────────────────────────────────────
  static const String eventGoal = 'goal';
  static const String eventMotm = 'motm';

  // ── Squad positions ───────────────────────────────────────────
  static const String positionStarter = 'starter';
  static const String positionSubstitute = 'substitute';
}
