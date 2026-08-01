import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:playerpath/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:playerpath/features/feed/data/repositories/feed_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late MockFeedRepository mockRepo;

  setUp(() {
    mockRepo = MockFeedRepository();
  });

  group('FeedCubit', () {
    blocTest<FeedCubit, FeedState>(
      'emits Loading then Loaded on success',
      build: () => FeedCubit(mockRepo),
      act: (cubit) async {
        when(() => mockRepo.getFeed()).thenAnswer((_) async => {
          'nearbyClubs': [{'id': '1', 'clubName': 'Stockport County', 'league': 'NPL'}],
          'clubsWithTrials': [],
          'suggestedClubs': [],
          'nearbyPlayers': [],
          'trendingPlayers': [],
        });
        await cubit.loadFeed();
      },
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepo.getFeed()).called(1);
      },
    );

    blocTest<FeedCubit, FeedState>(
      'emits Loading then Error on failure',
      build: () => FeedCubit(mockRepo),
      act: (cubit) async {
        when(() => mockRepo.getFeed()).thenThrow(Exception('Network error'));
        await cubit.loadFeed();
      },
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedError>(),
      ],
    );
  });
}
