import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PodcastDisplayWidget extends StatelessWidget {
  final String posterUrl;
  final String name;
  final BuildContext context;
  const PodcastDisplayWidget({
    Key? key,
    required this.name,
    required this.posterUrl,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheSize = (128.0 * MediaQuery.devicePixelRatioOf(context)).round();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: posterUrl,
          fit: BoxFit.cover,
          memCacheWidth: cacheSize,
          memCacheHeight: cacheSize,
          maxWidthDiskCache: cacheSize,
          maxHeightDiskCache: cacheSize,
          // The grid is retained now, but disabling fades also prevents a
          // cached image from looking like a network refresh after a rebuild.
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          errorWidget: (context, url, error) => Icon(Icons.error),
          placeholder: (context, url) => Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ));
  }
}
