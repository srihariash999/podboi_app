import 'package:flutter/material.dart';
import 'package:podboi/DataModels/song.dart';
import 'package:podboi/Helpers/helpers.dart';

class QueueItem extends StatelessWidget {
  final bool isEmptyState;
  final Song song;
  final int index;
  final bool showDragHandle;
  final Function(int) onTap;
  const QueueItem({
    super.key,
    required this.index,
    required this.showDragHandle,
    required this.onTap,
    this.isEmptyState = false,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmptyState) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacityValue(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Text(
              "Nothing in Queue",
              style: TextStyle(
                fontSize: 24.0,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacityValue(0.8),
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            Text(
              "You can queue episodes to play next by swiping right on an episode.",
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacityValue(0.8),
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacityValue(0.1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Album artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                song.icon,
                height: 64.0,
                width: 64.0,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12.0),

            // Episode details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    song.album,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.4),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    song.name,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.8),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    Helpers.formatDurationToMinutes(
                      Duration(seconds: song.duration ?? 0),
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacityValue(0.4),
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Drag handle
            if (showDragHandle)
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: ReorderableDragStartListener(
                  key: ValueKey(index), // Important for reordering
                  index: index,
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacityValue(0.8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
