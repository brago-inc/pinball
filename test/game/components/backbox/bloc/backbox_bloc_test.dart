// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball_models/pinball_models.dart';
import 'package:pinball_repository/pinball_repository.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockPinballRepository extends Mock implements PinballRepository {
}

void main() {
  late PinballRepository pinballRepository;
  const emptyEntries = <LeaderboardEntryData>[];
  const filledEntries = [LeaderboardEntryData.empty];

  group('BackboxBloc', () {
    test('inits state with LeaderboardSuccessState when has entries', () {
      pinballRepository = _MockPinballRepository();
      final bloc = BackboxBloc(
        pinballRepository: pinballRepository,
        initialEntries: filledEntries,
      );
      expect(bloc.state, isA<LeaderboardSuccessState>());
    });

    test('inits state with LeaderboardFailureState when has no entries', () {
      pinballRepository = _MockPinballRepository();
      final bloc = BackboxBloc(
        pinballRepository: pinballRepository,
        initialEntries: null,
      );
      expect(bloc.state, isA<LeaderboardFailureState>());
    });

    blocTest<BackboxBloc, BackboxState>(
      'adds InitialsFormState on PlayerInitialsRequested',
      setUp: () {
        pinballRepository = _MockPinballRepository();
      },
      build: () => BackboxBloc(
        pinballRepository: pinballRepository,
        initialEntries: emptyEntries,
      ),
      act: (bloc) => bloc.add(
        PlayerInitialsRequested(
          score: 100,
          character: AndroidTheme(),
        ),
      ),
      expect: () => [
        InitialsFormState(score: 100, character: AndroidTheme()),
      ],
    );

    group('PlayerInitialsSubmitted', () {
      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, InitialsSuccessState] when submission succeeds',
        setUp: () {
          pinballRepository = _MockPinballRepository();
          when(
            () => pinballRepository.addLeaderboardEntry(
              LeaderboardEntryData(
                playerInitials: 'AAA',
                score: 10,
                character: CharacterType.dash,
              ),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(
          PlayerInitialsSubmitted(
            score: 10,
            initials: 'AAA',
            character: DashTheme(),
          ),
        ),
        expect: () => [
          LoadingState(),
          InitialsSuccessState(score: 10),
        ],
      );

      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, InitialsFailureState] when submission fails',
        setUp: () {
          pinballRepository = _MockPinballRepository();
          when(
            () => pinballRepository.addLeaderboardEntry(
              LeaderboardEntryData(
                playerInitials: 'AAA',
                score: 10,
                character: CharacterType.dash,
              ),
            ),
          ).thenThrow(Exception('Error'));
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(
          PlayerInitialsSubmitted(
            score: 10,
            initials: 'AAA',
            character: DashTheme(),
          ),
        ),
        expect: () => [
          LoadingState(),
          InitialsFailureState(score: 10, character: DashTheme()),
        ],
      );
    });

    group('ShareScoreRequested', () {
      blocTest<BackboxBloc, BackboxState>(
        'emits ShareState',
        setUp: () {
          pinballRepository = _MockPinballRepository();
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(
          ShareScoreRequested(score: 100),
        ),
        expect: () => [
          ShareState(score: 100),
        ],
      );
    });

    group('ShareScoreRequested', () {
      blocTest<BackboxBloc, BackboxState>(
        'emits ShareState',
        setUp: () {
          pinballRepository = _MockPinballRepository();
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(
          ShareScoreRequested(score: 100),
        ),
        expect: () => [
          ShareState(score: 100),
        ],
      );
    });

    group('LeaderboardRequested', () {
      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, LeaderboardSuccessState] when request succeeds',
        setUp: () {
          pinballRepository = _MockPinballRepository();
          when(
            () => pinballRepository.fetchTop10Leaderboard(),
          ).thenAnswer(
            (_) async => [LeaderboardEntryData.empty],
          );
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => [
          LoadingState(),
          LeaderboardSuccessState(entries: const [LeaderboardEntryData.empty]),
        ],
      );

      blocTest<BackboxBloc, BackboxState>(
        'adds [LoadingState, LeaderboardFailureState] when request fails',
        setUp: () {
          pinballRepository = _MockPinballRepository();
          when(
            () => pinballRepository.fetchTop10Leaderboard(),
          ).thenThrow(Exception('Error'));
        },
        build: () => BackboxBloc(
          pinballRepository: pinballRepository,
          initialEntries: emptyEntries,
        ),
        act: (bloc) => bloc.add(LeaderboardRequested()),
        expect: () => [
          LoadingState(),
          LeaderboardFailureState(),
        ],
      );
    });
  });
}
