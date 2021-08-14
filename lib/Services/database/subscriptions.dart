import 'package:hive/hive.dart';
import 'package:podcast_search/podcast_search.dart';

part 'subscriptions.g.dart';

@HiveType(typeId: 1)
class Subscription {
  Subscription({required this.podcast, required this.dateAdded});

  @HiveField(0)
  Item podcast;

  @HiveField(1)
  DateTime dateAdded;
}
