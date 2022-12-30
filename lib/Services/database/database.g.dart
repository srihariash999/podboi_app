// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class ListeningHistoryData extends DataClass
    implements Insertable<ListeningHistoryData> {
  final int id;
  final String url;
  final String artist;
  final String icon;
  final String album;
  final String duration;
  final String podcastName;
  final String podcastArtwork;
  final String listenedOn;
  final String name;
  const ListeningHistoryData(
      {required this.id,
      required this.url,
      required this.artist,
      required this.icon,
      required this.album,
      required this.duration,
      required this.podcastName,
      required this.podcastArtwork,
      required this.listenedOn,
      required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['artist'] = Variable<String>(artist);
    map['icon'] = Variable<String>(icon);
    map['album'] = Variable<String>(album);
    map['duration'] = Variable<String>(duration);
    map['podcast_name'] = Variable<String>(podcastName);
    map['podcast_artwork'] = Variable<String>(podcastArtwork);
    map['listened_on'] = Variable<String>(listenedOn);
    map['name'] = Variable<String>(name);
    return map;
  }

  ListeningHistoryCompanion toCompanion(bool nullToAbsent) {
    return ListeningHistoryCompanion(
      id: Value(id),
      url: Value(url),
      artist: Value(artist),
      icon: Value(icon),
      album: Value(album),
      duration: Value(duration),
      podcastName: Value(podcastName),
      podcastArtwork: Value(podcastArtwork),
      listenedOn: Value(listenedOn),
      name: Value(name),
    );
  }

  factory ListeningHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListeningHistoryData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      artist: serializer.fromJson<String>(json['artist']),
      icon: serializer.fromJson<String>(json['icon']),
      album: serializer.fromJson<String>(json['album']),
      duration: serializer.fromJson<String>(json['duration']),
      podcastName: serializer.fromJson<String>(json['podcast_name']),
      podcastArtwork: serializer.fromJson<String>(json['podcast_artwork']),
      listenedOn: serializer.fromJson<String>(json['listened_on']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'artist': serializer.toJson<String>(artist),
      'icon': serializer.toJson<String>(icon),
      'album': serializer.toJson<String>(album),
      'duration': serializer.toJson<String>(duration),
      'podcast_name': serializer.toJson<String>(podcastName),
      'podcast_artwork': serializer.toJson<String>(podcastArtwork),
      'listened_on': serializer.toJson<String>(listenedOn),
      'name': serializer.toJson<String>(name),
    };
  }

  ListeningHistoryData copyWith(
          {int? id,
          String? url,
          String? artist,
          String? icon,
          String? album,
          String? duration,
          String? podcastName,
          String? podcastArtwork,
          String? listenedOn,
          String? name}) =>
      ListeningHistoryData(
        id: id ?? this.id,
        url: url ?? this.url,
        artist: artist ?? this.artist,
        icon: icon ?? this.icon,
        album: album ?? this.album,
        duration: duration ?? this.duration,
        podcastName: podcastName ?? this.podcastName,
        podcastArtwork: podcastArtwork ?? this.podcastArtwork,
        listenedOn: listenedOn ?? this.listenedOn,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ListeningHistoryData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('artist: $artist, ')
          ..write('icon: $icon, ')
          ..write('album: $album, ')
          ..write('duration: $duration, ')
          ..write('podcastName: $podcastName, ')
          ..write('podcastArtwork: $podcastArtwork, ')
          ..write('listenedOn: $listenedOn, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, artist, icon, album, duration,
      podcastName, podcastArtwork, listenedOn, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListeningHistoryData &&
          other.id == this.id &&
          other.url == this.url &&
          other.artist == this.artist &&
          other.icon == this.icon &&
          other.album == this.album &&
          other.duration == this.duration &&
          other.podcastName == this.podcastName &&
          other.podcastArtwork == this.podcastArtwork &&
          other.listenedOn == this.listenedOn &&
          other.name == this.name);
}

class ListeningHistoryCompanion extends UpdateCompanion<ListeningHistoryData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> artist;
  final Value<String> icon;
  final Value<String> album;
  final Value<String> duration;
  final Value<String> podcastName;
  final Value<String> podcastArtwork;
  final Value<String> listenedOn;
  final Value<String> name;
  const ListeningHistoryCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.artist = const Value.absent(),
    this.icon = const Value.absent(),
    this.album = const Value.absent(),
    this.duration = const Value.absent(),
    this.podcastName = const Value.absent(),
    this.podcastArtwork = const Value.absent(),
    this.listenedOn = const Value.absent(),
    this.name = const Value.absent(),
  });
  ListeningHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String artist,
    required String icon,
    required String album,
    required String duration,
    required String podcastName,
    required String podcastArtwork,
    required String listenedOn,
    required String name,
  })  : url = Value(url),
        artist = Value(artist),
        icon = Value(icon),
        album = Value(album),
        duration = Value(duration),
        podcastName = Value(podcastName),
        podcastArtwork = Value(podcastArtwork),
        listenedOn = Value(listenedOn),
        name = Value(name);
  static Insertable<ListeningHistoryData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? artist,
    Expression<String>? icon,
    Expression<String>? album,
    Expression<String>? duration,
    Expression<String>? podcastName,
    Expression<String>? podcastArtwork,
    Expression<String>? listenedOn,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (artist != null) 'artist': artist,
      if (icon != null) 'icon': icon,
      if (album != null) 'album': album,
      if (duration != null) 'duration': duration,
      if (podcastName != null) 'podcast_name': podcastName,
      if (podcastArtwork != null) 'podcast_artwork': podcastArtwork,
      if (listenedOn != null) 'listened_on': listenedOn,
      if (name != null) 'name': name,
    });
  }

  ListeningHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? artist,
      Value<String>? icon,
      Value<String>? album,
      Value<String>? duration,
      Value<String>? podcastName,
      Value<String>? podcastArtwork,
      Value<String>? listenedOn,
      Value<String>? name}) {
    return ListeningHistoryCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      artist: artist ?? this.artist,
      icon: icon ?? this.icon,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      podcastName: podcastName ?? this.podcastName,
      podcastArtwork: podcastArtwork ?? this.podcastArtwork,
      listenedOn: listenedOn ?? this.listenedOn,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (podcastName.present) {
      map['podcast_name'] = Variable<String>(podcastName.value);
    }
    if (podcastArtwork.present) {
      map['podcast_artwork'] = Variable<String>(podcastArtwork.value);
    }
    if (listenedOn.present) {
      map['listened_on'] = Variable<String>(listenedOn.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListeningHistoryCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('artist: $artist, ')
          ..write('icon: $icon, ')
          ..write('album: $album, ')
          ..write('duration: $duration, ')
          ..write('podcastName: $podcastName, ')
          ..write('podcastArtwork: $podcastArtwork, ')
          ..write('listenedOn: $listenedOn, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class ListeningHistory extends Table
    with TableInfo<ListeningHistory, ListeningHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ListeningHistory(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
      'album', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
      'duration', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _podcastNameMeta =
      const VerificationMeta('podcastName');
  late final GeneratedColumn<String> podcastName = GeneratedColumn<String>(
      'podcast_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _podcastArtworkMeta =
      const VerificationMeta('podcastArtwork');
  late final GeneratedColumn<String> podcastArtwork = GeneratedColumn<String>(
      'podcast_artwork', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _listenedOnMeta =
      const VerificationMeta('listenedOn');
  late final GeneratedColumn<String> listenedOn = GeneratedColumn<String>(
      'listened_on', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        url,
        artist,
        icon,
        album,
        duration,
        podcastName,
        podcastArtwork,
        listenedOn,
        name
      ];
  @override
  String get aliasedName => _alias ?? 'listening_history';
  @override
  String get actualTableName => 'listening_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListeningHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('album')) {
      context.handle(
          _albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    } else if (isInserting) {
      context.missing(_albumMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('podcast_name')) {
      context.handle(
          _podcastNameMeta,
          podcastName.isAcceptableOrUnknown(
              data['podcast_name']!, _podcastNameMeta));
    } else if (isInserting) {
      context.missing(_podcastNameMeta);
    }
    if (data.containsKey('podcast_artwork')) {
      context.handle(
          _podcastArtworkMeta,
          podcastArtwork.isAcceptableOrUnknown(
              data['podcast_artwork']!, _podcastArtworkMeta));
    } else if (isInserting) {
      context.missing(_podcastArtworkMeta);
    }
    if (data.containsKey('listened_on')) {
      context.handle(
          _listenedOnMeta,
          listenedOn.isAcceptableOrUnknown(
              data['listened_on']!, _listenedOnMeta));
    } else if (isInserting) {
      context.missing(_listenedOnMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, podcastName},
      ];
  @override
  ListeningHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListeningHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      album: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration'])!,
      podcastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}podcast_name'])!,
      podcastArtwork: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}podcast_artwork'])!,
      listenedOn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}listened_on'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  ListeningHistory createAlias(String alias) {
    return ListeningHistory(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT names UNIQUE(name, podcast_name)ON CONFLICT REPLACE'];
  @override
  bool get dontWriteConstraints => true;
}

class SubscriptionData extends DataClass
    implements Insertable<SubscriptionData> {
  final int id;
  final String podcastName;
  final int? podcastId;
  final String feedUrl;
  final String artworkUrl;
  final DateTime dateAdded;
  DateTime? lastEpisodeDate;
  final int? trackCount;
  final DateTime? releaseDate;
  final String? country;
  final String? genre;
  final String? contentAdvisory;
  SubscriptionData(
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
      podcastId: podcastId == null && nullToAbsent
          ? const Value.absent()
          : Value(podcastId),
      feedUrl: Value(feedUrl),
      artworkUrl: Value(artworkUrl),
      dateAdded: Value(dateAdded),
      lastEpisodeDate: lastEpisodeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEpisodeDate),
      trackCount: trackCount == null && nullToAbsent
          ? const Value.absent()
          : Value(trackCount),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      genre:
          genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      contentAdvisory: contentAdvisory == null && nullToAbsent
          ? const Value.absent()
          : Value(contentAdvisory),
    );
  }

  factory SubscriptionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionData(
      id: serializer.fromJson<int>(json['id']),
      podcastName: serializer.fromJson<String>(json['podcast_name']),
      podcastId: serializer.fromJson<int?>(json['podcast_id']),
      feedUrl: serializer.fromJson<String>(json['feed_url']),
      artworkUrl: serializer.fromJson<String>(json['artwork_url']),
      dateAdded: serializer.fromJson<DateTime>(json['date_added']),
      lastEpisodeDate:
          serializer.fromJson<DateTime?>(json['last_episode_date']),
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
        lastEpisodeDate: lastEpisodeDate.present
            ? lastEpisodeDate.value
            : this.lastEpisodeDate,
        trackCount: trackCount.present ? trackCount.value : this.trackCount,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        country: country.present ? country.value : this.country,
        genre: genre.present ? genre.value : this.genre,
        contentAdvisory: contentAdvisory.present
            ? contentAdvisory.value
            : this.contentAdvisory,
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
  int get hashCode => Object.hash(
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
      contentAdvisory);
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

class Subscription extends Table
    with TableInfo<Subscription, SubscriptionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Subscription(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _podcastNameMeta =
      const VerificationMeta('podcastName');
  late final GeneratedColumn<String> podcastName = GeneratedColumn<String>(
      'podcast_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _podcastIdMeta =
      const VerificationMeta('podcastId');
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
      'podcast_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _feedUrlMeta =
      const VerificationMeta('feedUrl');
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
      'feed_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _artworkUrlMeta =
      const VerificationMeta('artworkUrl');
  late final GeneratedColumn<String> artworkUrl = GeneratedColumn<String>(
      'artwork_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _dateAddedMeta =
      const VerificationMeta('dateAdded');
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _lastEpisodeDateMeta =
      const VerificationMeta('lastEpisodeDate');
  late final GeneratedColumn<DateTime> lastEpisodeDate =
      GeneratedColumn<DateTime>('last_episode_date', aliasedName, true,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          $customConstraints: '');
  static const VerificationMeta _trackCountMeta =
      const VerificationMeta('trackCount');
  late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
      'track_count', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
      'release_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _contentAdvisoryMeta =
      const VerificationMeta('contentAdvisory');
  late final GeneratedColumn<String> contentAdvisory = GeneratedColumn<String>(
      'content_advisory', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
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
      context.handle(
          _podcastNameMeta,
          podcastName.isAcceptableOrUnknown(
              data['podcast_name']!, _podcastNameMeta));
    } else if (isInserting) {
      context.missing(_podcastNameMeta);
    }
    if (data.containsKey('podcast_id')) {
      context.handle(_podcastIdMeta,
          podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta));
    }
    if (data.containsKey('feed_url')) {
      context.handle(_feedUrlMeta,
          feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta));
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('artwork_url')) {
      context.handle(
          _artworkUrlMeta,
          artworkUrl.isAcceptableOrUnknown(
              data['artwork_url']!, _artworkUrlMeta));
    } else if (isInserting) {
      context.missing(_artworkUrlMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
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
      context.handle(
          _trackCountMeta,
          trackCount.isAcceptableOrUnknown(
              data['track_count']!, _trackCountMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {podcastId},
      ];
  @override
  SubscriptionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      podcastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}podcast_name'])!,
      podcastId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}podcast_id']),
      feedUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feed_url'])!,
      artworkUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artwork_url'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      lastEpisodeDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_episode_date']),
      trackCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}track_count']),
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}release_date']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre']),
      contentAdvisory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_advisory']),
    );
  }

  @override
  Subscription createAlias(String alias) {
    return Subscription(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['CONSTRAINT pod_id UNIQUE(podcast_id)ON CONFLICT ABORT'];
  @override
  bool get dontWriteConstraints => true;
}

class EpisodeData extends DataClass implements Insertable<EpisodeData> {
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['guid'] = Variable<String>(guid);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || publicationDate != null) {
      map['publication_date'] = Variable<DateTime>(publicationDate);
    }
    if (!nullToAbsent || contentUrl != null) {
      map['content_url'] = Variable<String>(contentUrl);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || season != null) {
      map['season'] = Variable<int>(season);
    }
    if (!nullToAbsent || episodeNumber != null) {
      map['episode_number'] = Variable<int>(episodeNumber);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || podcastId != null) {
      map['podcast_id'] = Variable<int>(podcastId);
    }
    if (!nullToAbsent || podcastName != null) {
      map['podcast_name'] = Variable<String>(podcastName);
    }
    return map;
  }

  EpisodeCompanion toCompanion(bool nullToAbsent) {
    return EpisodeCompanion(
      id: Value(id),
      guid: Value(guid),
      title: Value(title),
      description: Value(description),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      publicationDate: publicationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publicationDate),
      contentUrl: contentUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(contentUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      season:
          season == null && nullToAbsent ? const Value.absent() : Value(season),
      episodeNumber: episodeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeNumber),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      podcastId: podcastId == null && nullToAbsent
          ? const Value.absent()
          : Value(podcastId),
      podcastName: podcastName == null && nullToAbsent
          ? const Value.absent()
          : Value(podcastName),
    );
  }

  factory EpisodeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodeData(
      id: serializer.fromJson<int>(json['id']),
      guid: serializer.fromJson<String>(json['guid']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      link: serializer.fromJson<String?>(json['link']),
      publicationDate: serializer.fromJson<DateTime?>(json['publication_date']),
      contentUrl: serializer.fromJson<String?>(json['content_url']),
      imageUrl: serializer.fromJson<String?>(json['image_url']),
      author: serializer.fromJson<String?>(json['author']),
      season: serializer.fromJson<int?>(json['season']),
      episodeNumber: serializer.fromJson<int?>(json['episode_number']),
      duration: serializer.fromJson<int?>(json['duration']),
      podcastId: serializer.fromJson<int?>(json['podcast_id']),
      podcastName: serializer.fromJson<String?>(json['podcast_name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'guid': serializer.toJson<String>(guid),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'link': serializer.toJson<String?>(link),
      'publication_date': serializer.toJson<DateTime?>(publicationDate),
      'content_url': serializer.toJson<String?>(contentUrl),
      'image_url': serializer.toJson<String?>(imageUrl),
      'author': serializer.toJson<String?>(author),
      'season': serializer.toJson<int?>(season),
      'episode_number': serializer.toJson<int?>(episodeNumber),
      'duration': serializer.toJson<int?>(duration),
      'podcast_id': serializer.toJson<int?>(podcastId),
      'podcast_name': serializer.toJson<String?>(podcastName),
    };
  }

  EpisodeData copyWith(
          {int? id,
          String? guid,
          String? title,
          String? description,
          Value<String?> link = const Value.absent(),
          Value<DateTime?> publicationDate = const Value.absent(),
          Value<String?> contentUrl = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> author = const Value.absent(),
          Value<int?> season = const Value.absent(),
          Value<int?> episodeNumber = const Value.absent(),
          Value<int?> duration = const Value.absent(),
          Value<int?> podcastId = const Value.absent(),
          Value<String?> podcastName = const Value.absent()}) =>
      EpisodeData(
        id: id ?? this.id,
        guid: guid ?? this.guid,
        title: title ?? this.title,
        description: description ?? this.description,
        link: link.present ? link.value : this.link,
        publicationDate: publicationDate.present
            ? publicationDate.value
            : this.publicationDate,
        contentUrl: contentUrl.present ? contentUrl.value : this.contentUrl,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        author: author.present ? author.value : this.author,
        season: season.present ? season.value : this.season,
        episodeNumber:
            episodeNumber.present ? episodeNumber.value : this.episodeNumber,
        duration: duration.present ? duration.value : this.duration,
        podcastId: podcastId.present ? podcastId.value : this.podcastId,
        podcastName: podcastName.present ? podcastName.value : this.podcastName,
      );
  @override
  String toString() {
    return (StringBuffer('EpisodeData(')
          ..write('id: $id, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('link: $link, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('author: $author, ')
          ..write('season: $season, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('duration: $duration, ')
          ..write('podcastId: $podcastId, ')
          ..write('podcastName: $podcastName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      guid,
      title,
      description,
      link,
      publicationDate,
      contentUrl,
      imageUrl,
      author,
      season,
      episodeNumber,
      duration,
      podcastId,
      podcastName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeData &&
          other.id == this.id &&
          other.guid == this.guid &&
          other.title == this.title &&
          other.description == this.description &&
          other.link == this.link &&
          other.publicationDate == this.publicationDate &&
          other.contentUrl == this.contentUrl &&
          other.imageUrl == this.imageUrl &&
          other.author == this.author &&
          other.season == this.season &&
          other.episodeNumber == this.episodeNumber &&
          other.duration == this.duration &&
          other.podcastId == this.podcastId &&
          other.podcastName == this.podcastName);
}

class EpisodeCompanion extends UpdateCompanion<EpisodeData> {
  final Value<int> id;
  final Value<String> guid;
  final Value<String> title;
  final Value<String> description;
  final Value<String?> link;
  final Value<DateTime?> publicationDate;
  final Value<String?> contentUrl;
  final Value<String?> imageUrl;
  final Value<String?> author;
  final Value<int?> season;
  final Value<int?> episodeNumber;
  final Value<int?> duration;
  final Value<int?> podcastId;
  final Value<String?> podcastName;
  const EpisodeCompanion({
    this.id = const Value.absent(),
    this.guid = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.link = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.contentUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.author = const Value.absent(),
    this.season = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.duration = const Value.absent(),
    this.podcastId = const Value.absent(),
    this.podcastName = const Value.absent(),
  });
  EpisodeCompanion.insert({
    this.id = const Value.absent(),
    required String guid,
    required String title,
    required String description,
    this.link = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.contentUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.author = const Value.absent(),
    this.season = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.duration = const Value.absent(),
    this.podcastId = const Value.absent(),
    this.podcastName = const Value.absent(),
  })  : guid = Value(guid),
        title = Value(title),
        description = Value(description);
  static Insertable<EpisodeData> custom({
    Expression<int>? id,
    Expression<String>? guid,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? link,
    Expression<DateTime>? publicationDate,
    Expression<String>? contentUrl,
    Expression<String>? imageUrl,
    Expression<String>? author,
    Expression<int>? season,
    Expression<int>? episodeNumber,
    Expression<int>? duration,
    Expression<int>? podcastId,
    Expression<String>? podcastName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guid != null) 'guid': guid,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (link != null) 'link': link,
      if (publicationDate != null) 'publication_date': publicationDate,
      if (contentUrl != null) 'content_url': contentUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (author != null) 'author': author,
      if (season != null) 'season': season,
      if (episodeNumber != null) 'episode_number': episodeNumber,
      if (duration != null) 'duration': duration,
      if (podcastId != null) 'podcast_id': podcastId,
      if (podcastName != null) 'podcast_name': podcastName,
    });
  }

  EpisodeCompanion copyWith(
      {Value<int>? id,
      Value<String>? guid,
      Value<String>? title,
      Value<String>? description,
      Value<String?>? link,
      Value<DateTime?>? publicationDate,
      Value<String?>? contentUrl,
      Value<String?>? imageUrl,
      Value<String?>? author,
      Value<int?>? season,
      Value<int?>? episodeNumber,
      Value<int?>? duration,
      Value<int?>? podcastId,
      Value<String?>? podcastName}) {
    return EpisodeCompanion(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      publicationDate: publicationDate ?? this.publicationDate,
      contentUrl: contentUrl ?? this.contentUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      season: season ?? this.season,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      duration: duration ?? this.duration,
      podcastId: podcastId ?? this.podcastId,
      podcastName: podcastName ?? this.podcastName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (publicationDate.present) {
      map['publication_date'] = Variable<DateTime>(publicationDate.value);
    }
    if (contentUrl.present) {
      map['content_url'] = Variable<String>(contentUrl.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (season.present) {
      map['season'] = Variable<int>(season.value);
    }
    if (episodeNumber.present) {
      map['episode_number'] = Variable<int>(episodeNumber.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (podcastName.present) {
      map['podcast_name'] = Variable<String>(podcastName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeCompanion(')
          ..write('id: $id, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('link: $link, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('author: $author, ')
          ..write('season: $season, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('duration: $duration, ')
          ..write('podcastId: $podcastId, ')
          ..write('podcastName: $podcastName')
          ..write(')'))
        .toString();
  }
}

class Episode extends Table with TableInfo<Episode, EpisodeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Episode(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
      'link', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _publicationDateMeta =
      const VerificationMeta('publicationDate');
  late final GeneratedColumn<DateTime> publicationDate =
      GeneratedColumn<DateTime>('publication_date', aliasedName, true,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          $customConstraints: '');
  static const VerificationMeta _contentUrlMeta =
      const VerificationMeta('contentUrl');
  late final GeneratedColumn<String> contentUrl = GeneratedColumn<String>(
      'content_url', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _seasonMeta = const VerificationMeta('season');
  late final GeneratedColumn<int> season = GeneratedColumn<int>(
      'season', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _episodeNumberMeta =
      const VerificationMeta('episodeNumber');
  late final GeneratedColumn<int> episodeNumber = GeneratedColumn<int>(
      'episode_number', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _podcastIdMeta =
      const VerificationMeta('podcastId');
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
      'podcast_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _podcastNameMeta =
      const VerificationMeta('podcastName');
  late final GeneratedColumn<String> podcastName = GeneratedColumn<String>(
      'podcast_name', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        guid,
        title,
        description,
        link,
        publicationDate,
        contentUrl,
        imageUrl,
        author,
        season,
        episodeNumber,
        duration,
        podcastId,
        podcastName
      ];
  @override
  String get aliasedName => _alias ?? 'episode';
  @override
  String get actualTableName => 'episode';
  @override
  VerificationContext validateIntegrity(Insertable<EpisodeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
          _linkMeta, link.isAcceptableOrUnknown(data['link']!, _linkMeta));
    }
    if (data.containsKey('publication_date')) {
      context.handle(
          _publicationDateMeta,
          publicationDate.isAcceptableOrUnknown(
              data['publication_date']!, _publicationDateMeta));
    }
    if (data.containsKey('content_url')) {
      context.handle(
          _contentUrlMeta,
          contentUrl.isAcceptableOrUnknown(
              data['content_url']!, _contentUrlMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('season')) {
      context.handle(_seasonMeta,
          season.isAcceptableOrUnknown(data['season']!, _seasonMeta));
    }
    if (data.containsKey('episode_number')) {
      context.handle(
          _episodeNumberMeta,
          episodeNumber.isAcceptableOrUnknown(
              data['episode_number']!, _episodeNumberMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('podcast_id')) {
      context.handle(_podcastIdMeta,
          podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta));
    }
    if (data.containsKey('podcast_name')) {
      context.handle(
          _podcastNameMeta,
          podcastName.isAcceptableOrUnknown(
              data['podcast_name']!, _podcastNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EpisodeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      link: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}link']),
      publicationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}publication_date']),
      contentUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_url']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      season: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season']),
      episodeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}episode_number']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration']),
      podcastId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}podcast_id']),
      podcastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}podcast_name']),
    );
  }

  @override
  Episode createAlias(String alias) {
    return Episode(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'PRIMARY KEY(id)',
        'FOREIGN KEY(podcast_id)REFERENCES subscription(podcast_id)ON UPDATE NO ACTION ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

abstract class _$MyDb extends GeneratedDatabase {
  _$MyDb(QueryExecutor e) : super(e);
  late final ListeningHistory listeningHistory = ListeningHistory(this);
  late final Subscription subscription = Subscription(this);
  late final Episode episode = Episode(this);
  Future<int> insertLHI(
      String url,
      String artist,
      String icon,
      String album,
      String duration,
      String podcastName,
      String podcastArtwork,
      String listenedOn,
      String name) {
    return customInsert(
      'INSERT INTO listening_history (url, artist, icon, album, duration, podcast_name, podcast_artwork, listened_on, name) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)',
      variables: [
        Variable<String>(url),
        Variable<String>(artist),
        Variable<String>(icon),
        Variable<String>(album),
        Variable<String>(duration),
        Variable<String>(podcastName),
        Variable<String>(podcastArtwork),
        Variable<String>(listenedOn),
        Variable<String>(name)
      ],
      updates: {listeningHistory},
    );
  }

  Selectable<ListeningHistoryData> selectLHIUsingId(
      String name, String podcastName) {
    return customSelect(
        'SELECT * FROM listening_history WHERE name = ?1 AND podcast_name = ?2',
        variables: [
          Variable<String>(name),
          Variable<String>(podcastName)
        ],
        readsFrom: {
          listeningHistory,
        }).asyncMap(listeningHistory.mapFromRow);
  }

  Selectable<ListeningHistoryData> selectAllLHIs() {
    return customSelect(
        'SELECT * FROM listening_history ORDER BY listened_on DESC',
        variables: [],
        readsFrom: {
          listeningHistory,
        }).asyncMap(listeningHistory.mapFromRow);
  }

  Future<int> deleteLHIUsingId(int id) {
    return customUpdate(
      'DELETE FROM listening_history WHERE id = ?1',
      variables: [Variable<int>(id)],
      updates: {listeningHistory},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> insertSubscription(
      String podcastName,
      int? podcastId,
      String feedUrl,
      String artworkUrl,
      DateTime dateAdded,
      DateTime? lastEpisodeDate,
      int? trackCount,
      DateTime? releaseDate,
      String? country,
      String? genre,
      String? contentAdvisory) {
    return customInsert(
      'INSERT INTO subscription (podcast_name, podcast_id, feed_url, artwork_url, date_added, last_episode_date, track_count, release_date, country, genre, content_advisory) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)',
      variables: [
        Variable<String>(podcastName),
        Variable<int>(podcastId),
        Variable<String>(feedUrl),
        Variable<String>(artworkUrl),
        Variable<DateTime>(dateAdded),
        Variable<DateTime>(lastEpisodeDate),
        Variable<int>(trackCount),
        Variable<DateTime>(releaseDate),
        Variable<String>(country),
        Variable<String>(genre),
        Variable<String>(contentAdvisory)
      ],
      updates: {subscription},
    );
  }

  Selectable<SubscriptionData> selectSubscriptionUsingId(int? podcastId) {
    return customSelect('SELECT * FROM subscription WHERE podcast_id = ?1',
        variables: [
          Variable<int>(podcastId)
        ],
        readsFrom: {
          subscription,
        }).asyncMap(subscription.mapFromRow);
  }

  Selectable<SubscriptionData> selectAllSubscriptions() {
    return customSelect('SELECT * FROM subscription',
        variables: [],
        readsFrom: {
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

  Future<int> insertEpisode(
      String guid,
      String title,
      String description,
      String? link,
      DateTime? publicationDate,
      String? contentUrl,
      String? imageUrl,
      String? author,
      int? season,
      int? episodeNumber,
      int? duration,
      int? podcastId,
      String? podcastName) {
    return customInsert(
      'INSERT INTO episode (guid, title, description, link, publication_date, content_url, image_url, author, season, episode_number, duration, podcast_id, podcast_name) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13)',
      variables: [
        Variable<String>(guid),
        Variable<String>(title),
        Variable<String>(description),
        Variable<String>(link),
        Variable<DateTime>(publicationDate),
        Variable<String>(contentUrl),
        Variable<String>(imageUrl),
        Variable<String>(author),
        Variable<int>(season),
        Variable<int>(episodeNumber),
        Variable<int>(duration),
        Variable<int>(podcastId),
        Variable<String>(podcastName)
      ],
      updates: {episode},
    );
  }

  Selectable<EpisodeData> selectEpisodesUsingPodcastId(int? podcastId) {
    return customSelect('SELECT * FROM episode WHERE podcast_id = ?1',
        variables: [
          Variable<int>(podcastId)
        ],
        readsFrom: {
          episode,
        }).asyncMap(episode.mapFromRow);
  }

  Future<int> deleteEpisodeOfPodcast(int? podcastId) {
    return customUpdate(
      'DELETE FROM episode WHERE podcast_id = ?1',
      variables: [Variable<int>(podcastId)],
      updates: {episode},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [listeningHistory, subscription, episode];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('subscription',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('episode', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
