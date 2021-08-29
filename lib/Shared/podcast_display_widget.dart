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
    return Container(
      height: 160.0,
      width: 100.0,
      margin: EdgeInsets.only(left: 6.0, right: 6.0),
      child: Column(
        children: [
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              posterUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
