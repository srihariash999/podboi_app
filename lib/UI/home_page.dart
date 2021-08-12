import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            buildTopUi(),
            buildSearchRow(context),
            buildDiscoverPodcastsRow(context),
            buildNewEpisodes(),
          ],
        ),
      ),
    );
  }

  Padding buildNewEpisodes() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Episodes",
            style: TextStyle(
              fontFamily: 'Segoe',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                EpisodeDisplayWidget(
                  posterUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/99%25_Invisible_logo.jpg/1200px-99%25_Invisible_logo.jpg",
                  episodeTitle: "454- War,Famine,Pestilence, and Design",
                  episodeDuration: "31m",
                  episodeUploadDate: "Yesterday",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.black.withOpacity(0.20),
                  ),
                ),
                EpisodeDisplayWidget(
                  posterUrl:
                      "https://upload.wikimedia.org/wikipedia/en/e/e1/No_Such_Thing_As_A_Fish_logo.jpg",
                  episodeTitle:
                      "No Such Thing As Crossing the Futility Boundary",
                  episodeDuration: "51m",
                  episodeUploadDate: "Friday",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.black.withOpacity(0.20),
                  ),
                ),
                EpisodeDisplayWidget(
                  posterUrl:
                      "https://megaphone.imgix.net/podcasts/9a4c2c2a-3e8b-11e8-bd53-9b1115bac0fa/image/uploads_2F1525125320167-fd4zi01j82i-e7a9a485ccc4505ac3ddaacdb5fbfd57_2Fdecoder-ring-3000px.jpg?w=525&h=525",
                  episodeTitle: "Selling Out",
                  episodeDuration: "49m",
                  episodeUploadDate: "Friday",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.black.withOpacity(0.20),
                  ),
                ),
                EpisodeDisplayWidget(
                  posterUrl:
                      "https://is4-ssl.mzstatic.com/image/thumb/Podcasts125/v4/2e/45/35/2e4535eb-6609-0b06-c703-69b2420b433d/mza_11307628467914885774.png/1200x1200bb.jpg",
                  episodeTitle: "Your Dinosaur Questions Answered",
                  episodeDuration: "1h",
                  episodeUploadDate: "21 July",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.black.withOpacity(0.20),
                  ),
                ),
                EpisodeDisplayWidget(
                  posterUrl:
                      "https://images.squarespace-cdn.com/content/v1/53bc57f0e4b00052ff4d7ccd/1479474490617-GFZQ09UDJYDS482NVHLJ/lore-logo-light.png?format=1500w",
                  episodeTitle: "Epsiode 175: Head Case ",
                  episodeDuration: "39m",
                  episodeUploadDate: "19 July",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildSearchRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12.0,
        bottom: 16.0,
        left: 34.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Icon(
              LineIcons.search,
              color: Colors.black.withOpacity(0.60),
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.black.withOpacity(0.30),
              ),
              child: TextField(
                cursorColor: Colors.black.withOpacity(0.30),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.60),
                ),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(0.30),
                  ),
                  focusColor: Colors.black.withOpacity(0.30),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.30),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.30),
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDiscoverPodcastsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover",
            style: TextStyle(
              fontFamily: 'Segoe',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            "Top podcasts today on Podboi",
            style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 14.0,
                fontWeight: FontWeight.w200,
                color: Colors.black.withOpacity(0.50)),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            height: 160.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: [
                PodcastDisplayWidget(
                  name: "99% invisible",
                  posterUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/99%25_Invisible_logo.jpg/1200px-99%25_Invisible_logo.jpg",
                ),
                PodcastDisplayWidget(
                  name: "No Such Thing As A Fish",
                  posterUrl:
                      "https://upload.wikimedia.org/wikipedia/en/e/e1/No_Such_Thing_As_A_Fish_logo.jpg",
                ),
                PodcastDisplayWidget(
                  name: "Decoder Ring",
                  posterUrl:
                      "https://megaphone.imgix.net/podcasts/9a4c2c2a-3e8b-11e8-bd53-9b1115bac0fa/image/uploads_2F1525125320167-fd4zi01j82i-e7a9a485ccc4505ac3ddaacdb5fbfd57_2Fdecoder-ring-3000px.jpg?w=525&h=525",
                ),
                PodcastDisplayWidget(
                  name: "Terrible Lizards",
                  posterUrl:
                      "https://is4-ssl.mzstatic.com/image/thumb/Podcasts125/v4/2e/45/35/2e4535eb-6609-0b06-c703-69b2420b433d/mza_11307628467914885774.png/1200x1200bb.jpg",
                ),
                PodcastDisplayWidget(
                  name: "Lore",
                  posterUrl:
                      "https://images.squarespace-cdn.com/content/v1/53bc57f0e4b00052ff4d7ccd/1479474490617-GFZQ09UDJYDS482NVHLJ/lore-logo-light.png?format=1500w",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTopUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  LineIcons.bars,
                ),
              ),
              Container(
                height: 60.0,
                width: 55.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.network(
                  "https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Text(
                "Hi Howell",
                style: TextStyle(
                  // fontFamily: 'Segoe',
                  fontSize: 26.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Search for podcasts that interest you",
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 16.0,
                  color: Colors.black.withOpacity(0.50),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

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

class PodcastDisplayWidget extends StatelessWidget {
  final String posterUrl;
  final String name;
  const PodcastDisplayWidget({
    Key? key,
    required this.name,
    required this.posterUrl,
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
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
