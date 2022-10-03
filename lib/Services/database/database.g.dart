// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SubscriptionData extends DataClass implements Insertable<SubscriptionData> {
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
  const SubscriptionData({
    required this.id,
    required this.podcastName,
    this.podcastId,
    required this.feedUrl,
    required this.artworkUrl,
    required this.dateAdded,
    required this.lastEpisodeDate,
    required this.trackCount,
    required this.releaseDate,
    required this.country,
    required this.genre,
    required this.contentAdvisory,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['podcast_name'] = Variable<String>(podcastName);
    if (!nullToAbsent || podcastId != null) {
      map['podcast_id'] = Variable<int>(podcastId);
    }
    map['feed_url'] = Variable<String>(feedUrl);
    map['artwork_url'] = Variable<String>(artworkUrl);
    map['date_added'] = Variable<DateTime>(dateAdded);
    if (!nullToAbsent || lastEpisodeDate != null) {
      map['last_episode_date'] = Variable<DateTime>(lastEpisodeDate);
    }
    if (!nullToAbsent || trackCount != null) {
      map['track_count'] = Variable<int>(trackCount);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || contentAdvisory != null) {
      map['content_advisory'] = Variable<String>(contentAdvisory);
    }
    return map;
  }

  SubscriptionCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionCompanion(
      id: Value(id),
      podcastName: Value(podcastName),
      podcastId: podcastId == null && nullToAbsent ? const Value.absent() : Value(podcastId),
      feedUrl: Value(feedUrl),
      artworkUrl: Value(artworkUrl),
      dateAdded: Value(dateAdded),
      lastEpisodeDate: lastEpisodeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEpisodeDate),
      trackCount: trackCount == null && nullToAbsent ? const Value.absent() : Value(trackCount),
      releaseDate:
          releaseDate == null && nullToAbsent ? const Value.absent() : Value(releaseDate),
      country: country == null && nullToAbsent ? const Value.absent() : Value(country),
      genre: genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      contentAdvisory: contentAdvisory == null && nullToAbsent
          ? const Value.absent()
          : Value(contentAdvisory),
    );
  }

  factory SubscriptionData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionData(
      id: serializer.fromJson<int>(json['id']),
      podcastName: serializer.fromJson<String>(json['podcast_name']),
      podcastId: serializer.fromJson<int?>(json['podcast_id']),
      feedUrl: serializer.fromJson<String>(json['feed_url']),
      artworkUrl: serializer.fromJson<String>(json['artwork_url']),
      dateAdded: serializer.fromJson<DateTime>(json['date_added']),
      lastEpisodeDate: serializer.fromJson<DateTime?>(json['last_episode_date']),
      trackCount: serializer.fromJson<int?>(json['track_count']),
      releaseDate: serializer.fromJson<DateTime?>(json['release_date']),
      country: serializer.fromJson<String?>(json['country']),
      genre: serializer.fromJson<String?>(json['genre']),
      contentAdvisory: serializer.fromJson<String?>(json['content_advisory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'podcast_name': serializer.toJson<String>(podcastName),
      'podcast_id': serializer.toJson<int?>(podcastId),
      'feed_url': serializer.toJson<String>(feedUrl),
      'artwork_url': serializer.toJson<String>(artworkUrl),
      'date_added': serializer.toJson<DateTime>(dateAdded),
      'last_episode_date': serializer.toJson<DateTime?>(lastEpisodeDate),
      'track_count': serializer.toJson<int?>(trackCount),
      'release_date': serializer.toJson<DateTime?>(releaseDate),
      'country': serializer.toJson<String?>(country),
      'genre': serializer.toJson<String?>(genre),
      'content_advisory': serializer.toJson<String?>(contentAdvisory),
    };
  }

  SubscriptionData copyWith(
          {int? id,
          String? podcastName,
          Value<int?> podcastId = const Value.absent(),
          String? feedUrl,
          String? artworkUrl,
          DateTime? dateAdded,
          Value<DateTime?> lastEpisodeDate = const Value.absent(),
          Value<int?> trackCount = const Value.absent(),
          Value<DateTime?> releaseDate = const Value.absent(),
          Value<String?> country = const Value.absent(),
          Value<String?> genre = const Value.absent(),
          Value<String?> contentAdvisory = const Value.absent()}) =>
      SubscriptionData(
        id: id ?? this.id,
        podcastName: podcastName ?? this.podcastName,
        podcastId: podcastId.present ? podcastId.value : this.podcastId,
        feedUrl: feedUrl ?? this.feedUrl,
        artworkUrl: artworkUrl ?? this.artworkUrl,
        dateAdded: dateAdded ?? this.dateAdded,
        lastEpisodeDate: lastEpisodeDate.present ? lastEpisodeDate.value : this.lastEpisodeDate,
        trackCount: trackCount.present ? trackCount.value : this.trackCount,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        country: country.present ? country.value : this.country,
        genre: genre.present ? genre.value : this.genre,
        contentAdvisory: contentAdvisory.present ? contentAdvisory.value : this.contentAdvisory,
      );
  @override
  String toString() {
    return (StringBuffer('SubscriptionData(')
          ..write('id: $id, ')
          ..write('podcastName: $podcastName, ')
          ..write('podcastId: $podcastId, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastEpisodeDate: $lastEpisodeDate, ')
          ..write('trackCount: $trackCount, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('country: $country, ')
          ..write('genre: $genre, ')
          ..write('contentAdvisory: $contentAdvisory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, podcastName, podcastId, feedUrl, artworkUrl, dateAdded,
      lastEpisodeDate, trackCount, releaseDate, country, genre, contentAdvisory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionData &&
          other.id == this.id &&
          other.podcastName == this.podcastName &&
          other.podcastId == this.podcastId &&
          other.feedUrl == this.feedUrl &&
          other.artworkUrl == this.artworkUrl &&
          other.dateAdded == this.dateAdded &&
          other.lastEpisodeDate == this.lastEpisodeDate &&
          other.trackCount == this.trackCount &&
          other.releaseDate == this.releaseDate &&
          other.country == this.country &&
          other.genre == this.genre &&
          other.contentAdvisory == this.contentAdvisory);
}

class SubscriptionCompanion extends UpdateCompanion<SubscriptionData> {
  final Value<int> id;
  final Value<String> podcastName;
  final Value<int?> podcastId;
  final Value<String> feedUrl;
  final Value<String> artworkUrl;
  final Value<DateTime> dateAdded;
  final Value<DateTime?> lastEpisodeDate;
  final Value<int?> trackCount;
  final Value<DateTime?> releaseDate;
  final Value<String?> country;
  final Value<String?> genre;
  final Value<String?> contentAdvisory;
  const SubscriptionCompanion({
    this.id = const Value.absent(),
    this.podcastName = const Value.absent(),
    this.podcastId = const Value.absent(),
    this.feedUrl = const Value.absent(),
    this.artworkUrl = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastEpisodeDate = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.country = const Value.absent(),
    this.genre = const Value.absent(),
    this.contentAdvisory = const Value.absent(),
  });
  SubscriptionCompanion.insert({
    this.id = const Value.absent(),
    required String podcastName,
    this.podcastId = const Value.absent(),
    required String feedUrl,
    required String artworkUrl,
    required DateTime dateAdded,
    this.lastEpisodeDate = const Value.absent(),
    this.trackCount = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.country = const Value.absent(),
    this.genre = const Value.absent(),
    this.contentAdvisory = const Value.absent(),
  })  : podcastName = Value(podcastName),
        feedUrl = Value(feedUrl),
        artworkUrl = Value(artworkUrl),
        dateAdded = Value(dateAdded);
  static Insertable<SubscriptionData> custom({
    Expression<int>? id,
    Expression<String>? podcastName,
    Expression<int>? podcastId,
    Expression<String>? feedUrl,
    Expression<String>? artworkUrl,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? lastEpisodeDate,
    Expression<int>? trackCount,
    Expression<DateTime>? releaseDate,
    Expression<String>? country,
    Expression<String>? genre,
    Expression<String>? contentAdvisory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (podcastName != null) 'podcast_name': podcastName,
      if (podcastId != null) 'podcast_id': podcastId,
      if (feedUrl != null) 'feed_url': feedUrl,
      if (artworkUrl != null) 'artwork_url': artworkUrl,
      if (dateAdded != null) 'date_added': dateAdded,
      if (lastEpisodeDate != null) 'last_episode_date': lastEpisodeDate,
      if (trackCount != null) 'track_count': trackCount,
      if (releaseDate != null) 'release_date': releaseDate,
      if (country != null) 'country': country,
      if (genre != null) 'genre': genre,
      if (contentAdvisory != null) 'content_advisory': contentAdvisory,
    });
  }

  SubscriptionCompanion copyWith(
      {Value<int>? id,
      Value<String>? podcastName,
      Value<int?>? podcastId,
      Value<String>? feedUrl,
      Value<String>? artworkUrl,
      Value<DateTime>? dateAdded,
      Value<DateTime?>? lastEpisodeDate,
      Value<int?>? trackCount,
      Value<DateTime?>? releaseDate,
      Value<String?>? country,
      Value<String?>? genre,
      Value<String?>? contentAdvisory}) {
    return SubscriptionCompanion(
      id: id ?? this.id,
      podcastName: podcastName ?? this.podcastName,
      podcastId: podcastId ?? this.podcastId,
      feedUrl: feedUrl ?? this.feedUrl,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      lastEpisodeDate: lastEpisodeDate ?? this.lastEpisodeDate,
      trackCount: trackCount ?? this.trackCount,
      releaseDate: releaseDate ?? this.releaseDate,
      country: country ?? this.country,
      genre: genre ?? this.genre,
      contentAdvisory: contentAdvisory ?? this.contentAdvisory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (podcastName.present) {
      map['podcast_name'] = Variable<String>(podcastName.value);
    }
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (artworkUrl.present) {
      map['artwork_url'] = Variable<String>(artworkUrl.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (lastEpisodeDate.present) {
      map['last_episode_date'] = Variable<DateTime>(lastEpisodeDate.value);
    }
    if (trackCount.present) {
      map['track_count'] = Variable<int>(trackCount.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (contentAdvisory.present) {
      map['content_advisory'] = Variable<String>(contentAdvisory.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionCompanion(')
          ..write('id: $id, ')
          ..write('podcastName: $podcastName, ')
          ..write('podcastId: $podcastId, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastEpisodeDate: $lastEpisodeDate, ')
          ..write('trackCount: $trackCount, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('country: $country, ')
          ..write('genre: $genre, ')
          ..write('contentAdvisory: $contentAdvisory')
          ..write(')'))
        .toString();
  }
}

class Subscription extends Table with TableInfo<Subscription, SubscriptionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Subscription(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _podcastNameMeta = const VerificationMeta('podcastName');
  late final GeneratedColumn<String> podcastName = GeneratedColumn<String>(
      'podcast_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  final VerificationMeta _podcastIdMeta = const VerificationMeta('podcastId');
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
      'podcast_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _feedUrlMeta = const VerificationMeta('feedUrl');
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
      'feed_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  final VerificationMeta _artworkUrlMeta = const VerificationMeta('artworkUrl');
  late final GeneratedColumn<String> artworkUrl = GeneratedColumn<String>(
      'artwork_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  final VerificationMeta _dateAddedMeta = const VerificationMeta('dateAdded');
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true, $customConstraints: 'NOT NULL');
  final VerificationMeta _lastEpisodeDateMeta = const VerificationMeta('lastEpisodeDate');
  late final GeneratedColumn<DateTime> lastEpisodeDate = GeneratedColumn<DateTime>(
      'last_episode_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _trackCountMeta = const VerificationMeta('trackCount');
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
      'track_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _releaseDateMeta = const VerificationMeta('releaseDate');
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
      'release_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _countryMeta = const VerificationMeta('country');
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _genreMeta = const VerificationMeta('genre');
  late final GeneratedColumn<String> genre = GeneratedColumn<String>('genre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _contentAdvisoryMeta = const VerificationMeta('contentAdvisory');
  late final GeneratedColumn<String> contentAdvisory = GeneratedColumn<String>(
      'content_advisory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        podcastName,
        podcastId,
        feedUrl,
        artworkUrl,
        dateAdded,
        lastEpisodeDate,
        trackCount,
        releaseDate,
        country,
        genre,
        contentAdvisory
      ];
  @override
  String get aliasedName => _alias ?? 'subscription';
  @override
  String get actualTableName => 'subscription';
  @override
  VerificationContext validateIntegrity(Insertable<SubscriptionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('podcast_name')) {
      context.handle(_podcastNameMeta,
          podcastName.isAcceptableOrUnknown(data['podcast_name']!, _podcastNameMeta));
    } else if (isInserting) {
      context.missing(_podcastNameMeta);
    }
    if (data.containsKey('podcast_id')) {
      context.handle(
          _podcastIdMeta, podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta));
    }
    if (data.containsKey('feed_url')) {
      context.handle(
          _feedUrlMeta, feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta));
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('artwork_url')) {
      context.handle(_artworkUrlMeta,
          artworkUrl.isAcceptableOrUnknown(data['artwork_url']!, _artworkUrlMeta));
    } else if (isInserting) {
      context.missing(_artworkUrlMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(
          _dateAddedMeta, dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('last_episode_date')) {
      context.handle(
          _lastEpisodeDateMeta,
          lastEpisodeDate.isAcceptableOrUnknown(
              data['last_episode_date']!, _lastEpisodeDateMeta));
    }
    if (data.containsKey('track_count')) {
      context.handle(_trackCountMeta,
          trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(_releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('country')) {
      context.handle(
          _countryMeta, country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(_genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('content_advisory')) {
      context.handle(
          _contentAdvisoryMeta,
          contentAdvisory.isAcceptableOrUnknown(
              data['content_advisory']!, _contentAdvisoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionData(
      id: attachedDatabase.options.types.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      podcastName: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}podcast_name'])!,
      podcastId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}podcast_id']),
      feedUrl: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}feed_url'])!,
      artworkUrl: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}artwork_url'])!,
      dateAdded: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      lastEpisodeDate: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_episode_date']),
      trackCount: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}track_count']),
      releaseDate: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}release_date']),
      country: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      genre: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}genre']),
      contentAdvisory: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}content_advisory']),
    );
  }

  @override
  Subscription createAlias(String alias) {
    return Subscription(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT "pod_id" UNIQUE ("podcast_id" ASC) ON CONFLICT FAIL'];
  @override
  bool get dontWriteConstraints => true;
}

abstract class _$MyDb extends GeneratedDatabase {
  _$MyDb(QueryExecutor e) : super(e);
  late final Subscription subscription = Subscription(this);
  Future<int> insertSubscription(String podcastName, int? podcastId, String feedUrl,
      String artworkUrl, DateTime dateAdded, DateTime? lastEpisodeDate, int? trackCount) {
    return customInsert(
      'INSERT INTO subscription (podcast_name, podcast_id, feed_url, artwork_url, date_added, last_episode_date, track_count) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)',
      variables: [
        Variable<String>(podcastName),
        Variable<int>(podcastId),
        Variable<String>(feedUrl),
        Variable<String>(artworkUrl),
        Variable<DateTime>(dateAdded),
        Variable<DateTime>(lastEpisodeDate),
        Variable<int>(trackCount)
      ],
      updates: {subscription},
    );
  }

  Selectable<SubscriptionData> selectSubscriptionUsingId(int? podcastId) {
    return customSelect('SELECT * FROM subscription WHERE podcast_id = ?1', variables: [
      Variable<int>(podcastId)
    ], readsFrom: {
      subscription,
    }).asyncMap(subscription.mapFromRow);
  }

  Selectable<SubscriptionData> selectAllSubscriptions() {
    return customSelect('SELECT * FROM subscription', variables: [], readsFrom: {
      subscription,
    }).asyncMap(subscription.mapFromRow);
  }

  Future<int> deleteSubscriptionUsingId(int? podcastId) {
    return customUpdate(
      'DELETE FROM subscription WHERE podcast_id = ?1',
      variables: [Variable<int>(podcastId)],
      updates: {subscription},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [subscription];
}
