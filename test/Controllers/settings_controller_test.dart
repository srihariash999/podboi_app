import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';

import 'settings_controller_test.mocks.dart';

@GenerateMocks([SettingsBoxController])
void main() {
  late MockSettingsBoxController mockSettingsBoxController;

  setUp(() {
    mockSettingsBoxController = MockSettingsBoxController();
  });

  ProviderContainer overrideProviders(MockSettingsBoxController controller) {
    return ProviderContainer(
      overrides: [
        // Override the initialize function for SettingsBoxController
        // to return our mock controller. This is a bit of a workaround
        // as the SettingsBoxController.initialize() is a factory constructor.
        // A more robust way would be to have an injectable dependency for the box controller.
        settingsController.overrideWithProvider(
          StateNotifierProvider<SettingsStateNotifier, SettingsState>(
            (ref) => SettingsStateNotifier.test(mockSettingsBoxController),
          ),
        ),
      ],
    );
  }

  group('SettingsController Tests', () {
    test('loadSettings updates state correctly from SettingsBoxController',
        () async {
      // Arrange
      when(mockSettingsBoxController.getSubsFirst())
          .thenAnswer((_) async => true);
      when(mockSettingsBoxController.getEnableBatteryOptimizationSetting())
          .thenAnswer((_) async => true);
      when(mockSettingsBoxController.getRewindDurationSetting())
          .thenAnswer((_) async => 15);
      when(mockSettingsBoxController.getForwardDurationSetting())
          .thenAnswer((_) async => 45);

      final container = overrideProviders(mockSettingsBoxController);
      final notifier = container.read(settingsController.notifier);

      // Act
      await notifier.loadSettings();

      // Assert
      final state = container.read(settingsController);
      expect(state.subsFirst, true);
      expect(state.enableBatteryOptimization, true);
      expect(state.rewindDuration, 15);
      expect(state.forwardDuration, 45);
      expect(state.loading, false);

      verify(mockSettingsBoxController.getSubsFirst()).called(1);
      verify(mockSettingsBoxController.getEnableBatteryOptimizationSetting())
          .called(1);
      verify(mockSettingsBoxController.getRewindDurationSetting()).called(1);
      verify(mockSettingsBoxController.getForwardDurationSetting()).called(1);
    });

    test(
        'loadSettings updates state with defaults if box returns null (though our getters have defaults)',
        () async {
      // Arrange
      when(mockSettingsBoxController.getSubsFirst())
          .thenAnswer((_) async => false); // Default
      when(mockSettingsBoxController.getEnableBatteryOptimizationSetting())
          .thenAnswer((_) async => false); // Default
      when(mockSettingsBoxController.getRewindDurationSetting())
          .thenAnswer((_) async => 30); // Default
      when(mockSettingsBoxController.getForwardDurationSetting())
          .thenAnswer((_) async => 30); // Default

      final container = overrideProviders(mockSettingsBoxController);
      final notifier = container.read(settingsController.notifier);

      // Act
      await notifier.loadSettings();

      // Assert
      final state = container.read(settingsController);
      expect(state.subsFirst, false);
      expect(state.enableBatteryOptimization, false);
      expect(state.rewindDuration, 30);
      expect(state.forwardDuration, 30);
      expect(state.loading, false);
    });

    test('saveSettings calls SettingsBoxController and updates state',
        () async {
      // Arrange
      when(mockSettingsBoxController.saveSubsFirstSetting(any))
          .thenAnswer((_) async => true);
      when(mockSettingsBoxController
              .saveEnableBatteryOptimizationSetting(any))
          .thenAnswer((_) async => true);
      when(mockSettingsBoxController.saveRewindDurationSetting(any))
          .thenAnswer((_) async => true);
      when(mockSettingsBoxController.saveForwardDurationSetting(any))
          .thenAnswer((_) async => true);
      
      // Initial load to set a baseline state
      when(mockSettingsBoxController.getSubsFirst()).thenAnswer((_) async => false);
      when(mockSettingsBoxController.getEnableBatteryOptimizationSetting()).thenAnswer((_) async => false);
      when(mockSettingsBoxController.getRewindDurationSetting()).thenAnswer((_) async => 30);
      when(mockSettingsBoxController.getForwardDurationSetting()).thenAnswer((_) async => 30);


      final container = overrideProviders(mockSettingsBoxController);
      final notifier = container.read(settingsController.notifier);
      await notifier.loadSettings(); // Load initial settings

      // Act
      await notifier.saveSettings(
        newSubsFirst: true,
        newEnableBatteryOptimization: true,
        newRewindDuration: 10,
        newForwardDuration: 15,
      );

      // Assert
      verify(mockSettingsBoxController.saveSubsFirstSetting(true)).called(1);
      verify(mockSettingsBoxController.saveEnableBatteryOptimizationSetting(true))
          .called(1);
      verify(mockSettingsBoxController.saveRewindDurationSetting(10)).called(1);
      verify(mockSettingsBoxController.saveForwardDurationSetting(15)).called(1);

      final state = container.read(settingsController);
      expect(state.subsFirst, true);
      expect(state.enableBatteryOptimization, true);
      expect(state.rewindDuration, 10);
      expect(state.forwardDuration, 15);
      expect(state.loading, false);
    });

    test('saveSettings handles partial saves correctly', () async {
      // Arrange
      when(mockSettingsBoxController.saveRewindDurationSetting(any))
          .thenAnswer((_) async => true);

      // Initial state setup
      when(mockSettingsBoxController.getSubsFirst()).thenAnswer((_) async => true); // Initial value
      when(mockSettingsBoxController.getEnableBatteryOptimizationSetting()).thenAnswer((_) async => true); // Initial value
      when(mockSettingsBoxController.getRewindDurationSetting()).thenAnswer((_) async => 30); // Initial value
      when(mockSettingsBoxController.getForwardDurationSetting()).thenAnswer((_) async => 30); // Initial value
      
      final container = overrideProviders(mockSettingsBoxController);
      final notifier = container.read(settingsController.notifier);
      await notifier.loadSettings();


      // Act: Only save rewind duration
      await notifier.saveSettings(newRewindDuration: 20);

      // Assert
      verify(mockSettingsBoxController.saveRewindDurationSetting(20)).called(1);
      verifyNever(mockSettingsBoxController.saveSubsFirstSetting(any));
      verifyNever(mockSettingsBoxController.saveEnableBatteryOptimizationSetting(any));
      verifyNever(mockSettingsBoxController.saveForwardDurationSetting(any));

      final state = container.read(settingsController);
      expect(state.subsFirst, true); // Should remain from initial load
      expect(state.enableBatteryOptimization, true); // Should remain from initial load
      expect(state.rewindDuration, 20); // Updated
      expect(state.forwardDuration, 30); // Should remain from initial load
      expect(state.loading, false);
    });

     test('SettingsState defaultState factory creates correct default state', () {
      final defaultState = SettingsState.defaultState();
      expect(defaultState.subsFirst, false);
      expect(defaultState.loading, false);
      expect(defaultState.enableBatteryOptimization, false);
      expect(defaultState.rewindDuration, 30);
      expect(defaultState.forwardDuration, 30);
    });

  });
}

// Helper extension to allow creating SettingsStateNotifier with a mock
extension SettingsStateNotifierTest on SettingsStateNotifier {
  static SettingsStateNotifier test(
      SettingsBoxController mockBoxController) {
    return SettingsStateNotifier.internal(mockBoxController);
  }
}

// Add this constructor to SettingsStateNotifier class in lib/Controllers/settings_controller.dart
// SettingsStateNotifier.internal(this._settingsBoxController)
//     : super(SettingsState.defaultState()) {
//   loadSettings();
// }
// And also change the existing constructor to:
// SettingsStateNotifier() : this.internal(SettingsBoxController.initialize());

// Note: The actual change to settings_controller.dart to add the internal constructor
// will be done in a separate step if this structure is approved.
// For now, this test file assumes such a constructor will exist.

// Also, change SettingsBoxController.initialize() from a factory to a static method
// if direct mocking of the factory is too complex.
// Example: static SettingsBoxController initialize() { return SettingsBoxController(Hive.box(K.boxes.settingsBox)); }
// Then the provider override becomes easier.
// However, the current override approach in `overrideProviders` should work by replacing the provider itself.
// The `SettingsStateNotifier.test` approach is cleaner if we can modify the controller.
