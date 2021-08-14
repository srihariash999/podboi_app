import 'package:flutter/material.dart';

class EpisodeDisplayWidget extends StatelessWidget {
  final String posterUrl;
  final String episodeTitle;
  final String episodeDuration;
  final String episodeUploadDate;
  const EpisodeDisplayWidget({
    Key? key,
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
        children: [
          Container(
            height: 50.0,
            width: 50.0,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          episodeTitle.length > 30
                              ? episodeTitle.substring(0, 27) + '...'
                              : episodeTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        episodeDuration,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.black.withOpacity(0.50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    episodeUploadDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.30),
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