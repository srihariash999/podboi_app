import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/settings_controller.dart';

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
                        child: Consumer(builder: (context, ref, child) {
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
                        }),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
