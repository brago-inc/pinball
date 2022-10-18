import 'package:pinball_api/pinball_api.dart';

/// {@template pinball_repository}
/// A repository that handles pinball related requests.
/// {@endtemplate}
class PinballRepository {
  /// {@macro pinball_repository}
  const PinballRepository({
    required PinballApi pinballApi,
  })  : _pinballApi = pinballApi;

  final PinballApi _pinballApi;

  /// Provides a [Future] of all trending.
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    return _pinballApi.fetchTop10Leaderboard();
  }
}
