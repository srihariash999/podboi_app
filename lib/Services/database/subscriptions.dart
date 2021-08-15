import 'package:hive/hive.dart';

part 'subscriptions.g.dart';

@HiveType(typeId: 1)
class Subscription {
  Subscription({required this.podcast, required this.dateAdded});

  @HiveField(0)
  Map<String, dynamic> podcast;

  @HiveField(1)
  DateTime dateAdded;
}
