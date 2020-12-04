import 'package:flutter/widgets.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/widgets/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LocationText(
          text: 'Settings/Tests',
        ),
        CustomButton(
          text: 'Return to Onboarding (debug)',
          onTap: () {
            DebugController.instance.returnToOnboarding();
          },
        ),
        CustomButton(
          text: 'Clear database (debug)',
          onTap: () {
            SessionController.instance.clear();
          },
        ),
        CustomButton(
          text: 'green theme',
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('green_theme');
          },
        ),
        CustomButton(
          text: 'blue theme',
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('blue_theme');
          },
        ),
        CustomButton(
          text: 'red theme',
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('red_theme');
          },
        ),
      ],
    );
  }
}
