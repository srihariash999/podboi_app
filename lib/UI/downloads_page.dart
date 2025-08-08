import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/downloaded_episode.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Database/download_box_controller.dart';
import 'package:podboi/Shared/detailed_episode_widget.dart';
import 'package:podboi/UI/player/mini_player.dart';

final downloadsProvider = FutureProvider<List<DownloadedEpisode>>((ref) async {
  final downloadBoxController = DownloadBoxController();
  return downloadBoxController.getDownloads();
});

class DownloadsPage extends ConsumerWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsyncValue = ref.watch(downloadsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: Column(
        children: [
          Expanded(
            child: downloadsAsyncValue.when(
              data: (downloads) {
                if (downloads.isEmpty) {
                  return Center(
                    child: Text('No downloaded episodes yet.'),
                  );
                }
                return ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final download = downloads[index];
                    // This is a hack, DetailedEpsiodeViewWidget needs a SubscriptionData object.
                    // I will create a dummy one for now.
                    final dummySubscription = SubscriptionData(
                      id: 0,
                      podcastName: download.episode.author ?? 'Unknown',
                      artworkUrl: download.episode.imageUrl ?? '',
                      feedUrl: '',
                      dateAdded: DateTime.now(),
                    );
                    return DetailedEpsiodeViewWidget(
                      episodeData: download.episode,
                      podcast: dummySubscription,
                      ref: ref,
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
    );
  }
}
