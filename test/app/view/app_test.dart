import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_repository/pinball_repository.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockPinballRepository extends Mock implements PinballRepository {}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockPlatformHelper extends Mock implements PlatformHelper {
  @override
  bool get isMobile => false;
}

void main() {
  group('App', () {
    late PinballRepository pinballRepository;
    late ShareRepository shareRepository;
    late PinballAudioPlayer pinballAudioPlayer;
    late PlatformHelper platformHelper;

    setUp(() {
      pinballRepository = _MockPinballRepository();
      shareRepository = _MockShareRepository();
      pinballAudioPlayer = _MockPinballAudioPlayer();
      platformHelper = _MockPlatformHelper();
      when(pinballAudioPlayer.load).thenAnswer((_) => [Future.value]);
    });

    testWidgets('renders PinballGamePage', (tester) async {
      await tester.pumpWidget(
        App(
          pinballRepository: pinballRepository,
          shareRepository: shareRepository,
          pinballAudioPlayer: pinballAudioPlayer,
          platformHelper: platformHelper,
        ),
      );
      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.byType(PinballGamePage), findsOneWidget);
    });
  });
}
