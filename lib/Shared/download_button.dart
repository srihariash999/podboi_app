import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/DataModels/episode_data.dart';
import 'package:podboi/DataModels/subscription_data.dart';
import 'package:podboi/Helpers/helpers.dart';

class DownloadButton extends StatelessWidget {
  DownloadButton({
    super.key,
    required this.episodeData,
    required this.podcast,
    required this.isDownloaded,
    required this.downloadAction,
    required this.deleteAction,
    required this.isDownloading,
    required this.progress,
  });

  final EpisodeData episodeData;
  final SubscriptionData podcast;
  final bool isDownloaded;
  final Function() downloadAction;
  final Function() deleteAction;
  final isDownloading;
  final progress;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        if (isDownloading) {
          return SizedBox(
            width: 39.0,
            height: 36.0,
            child: _DownloadingButtonState(progress: progress),
          );
        }

        if (episodeData.downloadPath != null &&
            episodeData.downloadPath!.isNotEmpty) {
          return InkWell(
            onTap: deleteAction,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.secondary,
              size: 20.0,
            ),
          );
        }
        return InkWell(
          onTap: downloadAction,
          child: Icon(
            FeatherIcons.download,
            color: Theme.of(context).colorScheme.secondary,
            size: 20.0,
          ),
        );
      },
    );
  }
}

class _DownloadingButtonState extends StatelessWidget {
  const _DownloadingButtonState({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.secondary.withOpacityValue(0.70),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacityValue(0.2),
          strokeWidth: 2.0,
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }
}
