class SubscriptionData {
  final int id;
  final String podcastName;
  final int? podcastId;
  final String feedUrl;
  final String artworkUrl;
  final DateTime dateAdded;
  final DateTime? lastEpisodeDate;
  final int? trackCount;
  final DateTime? releaseDate;
  final String? country;
  final String? genre;
  final String? contentAdvisory;
  const SubscriptionData(
      {required this.id,
      required this.podcastName,
      this.podcastId,
      required this.feedUrl,
      required this.artworkUrl,
      required this.dateAdded,
      this.lastEpisodeDate,
      this.trackCount,
      this.releaseDate,
      this.country,
      this.genre,
      this.contentAdvisory});
}
