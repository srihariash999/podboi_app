import 'package:podboi/Helpers/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('formatDurationToMinutes', () {
    test(
      'Less than one minute',
      () {
        expect(
          Helpers.formatDurationToMinutes(Duration(seconds: 59)),
          "00 Minutes",
        );
      },
    );
    test(
      'More than one minute less than an hour',
      () {
        expect(
          Helpers.formatDurationToMinutes(Duration(seconds: 120)),
          "02 Minutes",
        );
      },
    );

    test(
      'More than an hour',
      () {
        expect(
          Helpers.formatDurationToMinutes(Duration(seconds: 4200)),
          "70 Minutes",
        );
      },
    );
  });

  group("formatDuration", () {
    test(
      'Less than one minute',
      () {
        expect(
          Helpers.formatDuration(Duration(seconds: 59)),
          "00:00:59",
        );
      },
    );

    test(
      'More than one minute less than an hour',
      () {
        expect(
          Helpers.formatDuration(Duration(minutes: 35, seconds: 29)),
          "00:35:29",
        );
      },
    );

    test(
      'More than an hour',
      () {
        expect(
          Helpers.formatDuration(Duration(hours: 1, minutes: 35, seconds: 42)),
          "01:35:42",
        );
      },
    );
  });
}
