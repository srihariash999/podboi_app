import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:podboi/Services/database/settings_box_controller.dart';
import 'package:podboi/UI/settings_page.dart';
// It's good practice to mock the battery_optimizer if its methods are called directly in UI event handlers.
// However, if its calls are encapsulated within the SettingsController, mocking SettingsController might be enough.
// For this example, let's assume SettingsController handles BatteryOptimizer interactions.
// If not, you'd add: import 'package:battery_optimizer/battery_optimizer.dart'; and mock it.

import 'settings_page_test.mocks.dart';

// Mock SettingsStateNotifier for controlling its state and verifying calls
class MockSettingsStateNotifier extends StateNotifier<SettingsState>
    with Mock
    implements SettingsStateNotifier {
  MockSettingsStateNotifier(SettingsState initialState) : super(initialState);

  @override
  Future<void> saveSettings({
    bool? newSubsFirst,
    bool? newEnableBatteryOptimization,
    int? newRewindDuration,
    int? newForwardDuration,
  }) async {
    // Allow super.saveSettings or specific mock implementation
    super.saveSettings(
      newSubsFirst: newSubsFirst,
      newEnableBatteryOptimization: newEnableBatteryOptimization,
      newRewindDuration: newRewindDuration,
      newForwardDuration: newForwardDuration,
    );
  }

  voidsetState(SettingsState newState) {
    state = newState;
  }
}

// We also need a mock for SettingsBoxController if SettingsStateNotifier is not fully mocked for behavior.
// However, since we are testing the UI, we'll mock the SettingsController directly.
@GenerateMocks([SettingsBoxController]) // Keep if settingsController.notifier directly uses it.
void main() {
  // Initial default state for our mock controller
  final defaultTestState = SettingsState.defaultState();

  late MockSettingsStateNotifier mockSettingsNotifier;

  setUp(() {
    // Reset the mock notifier for each test with a default state
    mockSettingsNotifier = MockSettingsStateNotifier(defaultTestState);
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        settingsController.overrideWithValue(mockSettingsNotifier),
      ],
      child: MaterialApp(
        home: Material(child: child), // Material for directionality, text styles
      ),
    );
  }

  group('SettingsPage Widget Tests', () {
    testWidgets('renders all settings sections and initial values',
        (WidgetTester tester) async {
      // Arrange
      // Use the default state for initial rendering
      when(mockSettingsNotifier.state).thenReturn(defaultTestState);


      await tester.pumpWidget(createTestWidget(SettingsPage()));

      // Assert
      expect(find.text('Layout'), findsOneWidget);
      expect(find.text("Put 'Subsctiptions' page as default first screen when you open podboi."), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(2)); // SubsFirst and Battery Opt
      
      expect(find.text('Battery Optimization'), findsOneWidget);
      expect(find.text("Enable battery optimization to save power when using podboi."), findsOneWidget);
      
      expect(find.text('Player Settings'), findsOneWidget);
      expect(find.text('Rewind Duration (seconds)'), findsOneWidget);
      expect(find.text('Forward Duration (seconds)'), findsOneWidget);
      expect(find.byType(DropdownButton<int>), findsNWidgets(2));

      // Check initial values based on defaultTestState
      Switch subsFirstSwitch = tester.widget(find.byType(Switch).at(0));
      expect(subsFirstSwitch.value, defaultTestState.subsFirst);

      Switch batteryOptSwitch = tester.widget(find.byType(Switch).at(1));
      expect(batteryOptSwitch.value, defaultTestState.enableBatteryOptimization);
      
      DropdownButton<int> rewindDropdown = tester.widget(find.byType(DropdownButton<int>).at(0));
      expect(rewindDropdown.value, defaultTestState.rewindDuration);
      
      DropdownButton<int> forwardDropdown = tester.widget(find.byType(DropdownButton<int>).at(1));
      expect(forwardDropdown.value, defaultTestState.forwardDuration);
    });

    testWidgets('tapping subs first switch calls saveSettings and updates UI',
        (WidgetTester tester) async {
      // Arrange
      final initialState = SettingsState.defaultState().copyWith(subsFirst: false);
      final mockNotifier = MockSettingsStateNotifier(initialState);
      final expectedNewState = initialState.copyWith(subsFirst: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [settingsController.overrideWithValue(mockNotifier)],
          child: MaterialApp(home: SettingsPage()),
        ),
      );
      
      // Ensure initial state is reflected
      Switch subsFirstSwitch = tester.widget(find.byType(Switch).first);
      expect(subsFirstSwitch.value, false);

      // Act
      await tester.tap(find.byType(Switch).first);
      await tester.pump(); // Process the tap

      // Simulate state update by the notifier
      mockNotifier.setState(expectedNewState);
      await tester.pump(); // Rebuild with new state

      // Assert
      // Verify saveSettings was called on the original mock instance passed to override
      verify(mockNotifier.saveSettings(newSubsFirst: true)).called(1);
      
      subsFirstSwitch = tester.widget(find.byType(Switch).first);
      expect(subsFirstSwitch.value, true);
    });


    testWidgets('tapping battery optimization switch calls saveSettings and updates UI',
        (WidgetTester tester) async {
      final initialState = defaultTestState.copyWith(enableBatteryOptimization: false);
      final mockNotifierWithInitialState = MockSettingsStateNotifier(initialState);
      // Stub the saveSettings method
      when(mockNotifierWithInitialState.saveSettings(newEnableBatteryOptimization: true)).thenAnswer((_) async {});


      await tester.pumpWidget(
         ProviderScope(
          overrides: [settingsController.overrideWithValue(mockNotifierWithInitialState)],
          child: MaterialApp(home: SettingsPage()),
        ),
      );
      
      // Initial state of the battery optimization switch
      Switch batterySwitch = tester.widget(find.byType(Switch).at(1)); // Assuming it's the second switch
      expect(batterySwitch.value, false);

      // Act
      await tester.tap(find.byType(Switch).at(1));
      await tester.pump();

      // Simulate state update
      mockNotifierWithInitialState.setState(initialState.copyWith(enableBatteryOptimization: true));
      await tester.pump();

      // Assert
      verify(mockNotifierWithInitialState.saveSettings(newEnableBatteryOptimization: true)).called(1);
      batterySwitch = tester.widget(find.byType(Switch).at(1));
      expect(batterySwitch.value, true);

      // Test turning it off
      when(mockNotifierWithInitialState.saveSettings(newEnableBatteryOptimization: false)).thenAnswer((_) async {});
      await tester.tap(find.byType(Switch).at(1));
      await tester.pump();
      mockNotifierWithInitialState.setState(initialState.copyWith(enableBatteryOptimization: false));
      await tester.pump();
      
      verify(mockNotifierWithInitialState.saveSettings(newEnableBatteryOptimization: false)).called(1);
      batterySwitch = tester.widget(find.byType(Switch).at(1));
      expect(batterySwitch.value, false);
    });

    testWidgets('changing rewind duration calls saveSettings and updates UI',
        (WidgetTester tester) async {
      final initialState = defaultTestState.copyWith(rewindDuration: 30);
      final mockNotifierWithInitialState = MockSettingsStateNotifier(initialState);
      when(mockNotifierWithInitialState.saveSettings(newRewindDuration: 15)).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [settingsController.overrideWithValue(mockNotifierWithInitialState)],
          child: MaterialApp(home: SettingsPage()),
        ),
      );

      // Find the Rewind Dropdown
      Finder rewindDropdownFinder = find.byWidgetPredicate(
        (Widget widget) => widget is DropdownButton<int> && widget.items!.length == 2 && widget.value == 30,
      );
      expect(rewindDropdownFinder, findsOneWidget);
      
      // Act
      await tester.tap(rewindDropdownFinder);
      await tester.pumpAndSettle(); // For animations and to ensure items are available

      // Tap the '10 seconds' item.
      await tester.tap(find.text('10 seconds').last);
      await tester.pumpAndSettle();

      // Simulate state update
      mockNotifierWithInitialState.setState(initialState.copyWith(rewindDuration: 10));
      await tester.pump();

      // Assert
      verify(mockNotifierWithInitialState.saveSettings(newRewindDuration: 10)).called(1);
      DropdownButton<int> updatedRewindDropdown = tester.widget(rewindDropdownFinder);
      expect(updatedRewindDropdown.value, 10);
    });

    testWidgets('changing forward duration calls saveSettings and updates UI',
        (WidgetTester tester) async {
      final initialState = defaultTestState.copyWith(forwardDuration: 10); // Start with 10 to change to 30
      final mockNotifierWithInitialState = MockSettingsStateNotifier(initialState);
      when(mockNotifierWithInitialState.saveSettings(newForwardDuration: 30)).thenAnswer((_) async {});

      await tester.pumpWidget(
         ProviderScope(
          overrides: [settingsController.overrideWithValue(mockNotifierWithInitialState)],
          child: MaterialApp(home: SettingsPage()),
        ),
      );
      
      Finder forwardDropdownFinder = find.byWidgetPredicate(
        (Widget widget) => widget is DropdownButton<int> && widget.items!.length == 2 && widget.value == 10,
      );
      expect(forwardDropdownFinder, findsOneWidget);


      // Act
      await tester.tap(forwardDropdownFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.text('30 seconds').last);
      await tester.pumpAndSettle();

      // Simulate state update
      mockNotifierWithInitialState.setState(initialState.copyWith(forwardDuration: 30));
      await tester.pump();

      // Assert
      verify(mockNotifierWithInitialState.saveSettings(newForwardDuration: 30)).called(1);
      DropdownButton<int> updatedForwardDropdown = tester.widget(forwardDropdownFinder);
      expect(updatedForwardDropdown.value, 30);
    });
  });
}

// Helper to make SettingsState copyable for tests
extension SettingsStateCopy on SettingsState {
  SettingsState copyWith({
    bool? subsFirst,
    bool? loading,
    bool? enableBatteryOptimization,
    int? rewindDuration,
    int? forwardDuration,
  }) {
    return SettingsState(
      subsFirst: subsFirst ?? this.subsFirst,
      loading: loading ?? this.loading,
      enableBatteryOptimization:
          enableBatteryOptimization ?? this.enableBatteryOptimization,
      rewindDuration: rewindDuration ?? this.rewindDuration,
      forwardDuration: forwardDuration ?? this.forwardDuration,
    );
  }
}
