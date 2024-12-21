class EpisodeData {
  final int id;
  final String guid;
  final String title;
  final String description;
  final String? link;
  final DateTime? publicationDate;
  final String? contentUrl;
  final String? imageUrl;
  final String? author;
  final int? season;
  final int? episodeNumber;
  final int? duration;
  final int? podcastId;
  final String? podcastName;
  const EpisodeData(
      {required this.id,
      required this.guid,
      required this.title,
      required this.description,
      this.link,
      this.publicationDate,
      this.contentUrl,
      this.imageUrl,
      this.author,
      this.season,
      this.episodeNumber,
      this.duration,
      this.podcastId,
      this.podcastName});
}
