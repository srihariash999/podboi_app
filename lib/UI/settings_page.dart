import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/settings_controller.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:battery_optimizer/battery_optimizer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'Segoe',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Layout",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).highlightColor,
                    fontFamily: 'Segoe',
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Put 'Subsctiptions' page as default first screen when you open podboi.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    SizedBox(
                      width: 48.0,
                      height: 32.0,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final stateVal =
                                ref.watch(settingsController).subsFirst;
                            return Switch(
                              activeColor: Theme.of(context).highlightColor,
                              value: stateVal,
                              onChanged: (val) {
                                ref
                                    .read(settingsController.notifier)
                                    .saveSettings(
                                      newSubsFirst: val,
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.secondary.withOpacityValue(0.2),
            height: 1.0,
          ),
          if (Platform.isAndroid)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Battery Optimization",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).highlightColor,
                      fontFamily: 'Segoe',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (!Navigator.of(context).mounted) return;

                      try {
                        BatteryOptimizer.requestDisableBatteryOptimization();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Battery optimization setting change updated.'),
                          ),
                        );
                      } catch (e) {
                        if (!Navigator.of(context).mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Could not determine battery optimization status: $e')),
                        );
                      }
                    },
                    child: Text("Manage Battery Optimization"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textStyle: TextStyle(
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Tap the button to check the current battery optimization status or to request changes if optimization is disabled for this app. This can help with background playback.",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacityValue(0.7),
                        fontFamily: 'Segoe',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (Platform.isAndroid)
            Divider(
              color:
                  Theme.of(context).colorScheme.secondary.withOpacityValue(0.2),
              height: 1.0,
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Player Settings",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).highlightColor,
                    fontFamily: 'Segoe',
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Rewind Duration",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Consumer(builder: (context, ref, child) {
                      final settings = ref.watch(settingsController);
                      return DropdownButton<int>(
                        value: settings.rewindDuration,
                        items: [10, 30].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString() + " seconds"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(settingsController.notifier).saveSettings(
                                  newRewindDuration: val,
                                );
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Forward Duration",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Consumer(builder: (context, ref, child) {
                      final settings = ref.watch(settingsController);
                      return DropdownButton<int>(
                        value: settings.forwardDuration,
                        items: [10, 30].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString() + " seconds"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(settingsController.notifier).saveSettings(
                                  newForwardDuration: val,
                                );
                          }
                        },
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.secondary.withOpacityValue(0.2),
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
