import 'dart:async';
import 'dart:convert';

import 'package:http_pinball_api/src/abstract_base_client.dart';
import 'package:pinball_api/pinball_api.dart';

/// {@template http_pinball_api}
/// A Flutter implementation of the [HttpPinballApi] that uses http.
/// {@endtemplate}
class HttpPinballApi extends PinballApi {
  /// {@macro http_pinball_api}
  HttpPinballApi({
    required AbstractBaseClient client,
  }) : _client = client;

  final AbstractBaseClient _client;

  @override
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    try {
      final res = await _client.get(Uri.parse('${_client.baseUrl}/leaderboard-list'));
      if (res.statusCode == 200) {
        return List<LeaderboardEntryData>.from(
            (jsonDecode(utf8.decode(res.bodyBytes)) as Iterable).map(
                  (x) => LeaderboardEntryData.fromJson(x as Map<String, dynamic>),
            ));
      }
      return [];
    } catch (error, stack) {
      throw FetchTop10LeaderboardException(error, stack);
    } finally {
      _client.close();
    }
  }

  @override
  Future<void> addLeaderboardEntry(LeaderboardEntryData entry) async {
    try {

    } catch (error, stack) {
      throw FetchLeaderboardException(error, stack);
    } finally {
      _client.close();
    }
  }

}
