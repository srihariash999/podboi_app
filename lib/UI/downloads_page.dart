import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/download_controller.dart';
import 'package:podboi/Shared/detailed_episode_widget.dart';
import 'package:podboi/Shared/simple_appbar.dart';
import 'package:podboi/UI/player/mini_player.dart';

class DownloadsPage extends ConsumerStatefulWidget {
  const DownloadsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends ConsumerState<DownloadsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadController.notifier).loadDownloads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadState = ref.watch(downloadController);

    final isLoading = downloadState.isLoading;
    final downloads = downloadState.downloads;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
              SimplePodboiAppBar(title: 'Downloads'),
              const SizedBox(height: 24.0),
              Expanded(
                child: RefreshIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  onRefresh: () =>
                      ref.read(downloadController.notifier).loadDownloads(),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        )
                      : downloads.isEmpty
                          ? Center(
                              child: Text('No downloaded episodes yet.'),
                            )
                          : Consumer(
                              builder: (context, ref, child) {
                                return ListView.builder(
                                  itemCount: downloads.length,
                                  itemBuilder: (context, index) {
                                    final download = downloads[index];
                                    return DetailedEpsiodeViewWidget(
                                      episodeData: download.episode,
                                      podcast: download.subscriptionData,
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
            ],
          ),
        ),
      ),
    );
  }
}
