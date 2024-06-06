import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Opens connection to database based on current user
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final path = await getDbFilePath();
    final file = File(path);
    return NativeDatabase(file);
  });
}

/// Gives the path to database sqlite file based on admission number
Future<String> getDbFilePath() async {
  final dbFolder = await getApplicationDocumentsDirectory();

  return p.join(dbFolder.path, "db_user.podboi.sqlite");
}

@DriftDatabase(
  include: {'drift_files/tables.drift'},
)
class MyDb extends _$MyDb {
  MyDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}
