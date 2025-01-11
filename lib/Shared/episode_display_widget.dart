import 'package:flutter/material.dart';

class EpisodeDisplayWidget extends StatelessWidget {
  final BuildContext context;
  final String posterUrl;
  final String episodeTitle;
  final String episodeDuration;
  final String episodeUploadDate;
  const EpisodeDisplayWidget({
    Key? key,
    required this.context,
    required this.posterUrl,
    required this.episodeTitle,
    required this.episodeDuration,
    required this.episodeUploadDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              posterUrl,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          episodeTitle,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                        child: Text(
                          episodeDuration,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Played : " + episodeUploadDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
