import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The localizations for the application.
class MyLocalizations {
  /// The constructor.
  const MyLocalizations(this.locale);

  /// The current locale.
  final Locale locale;

  /// Returns the instance for the current locale.
  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static final Map<String, Map<String, dynamic>> _localizedValues = {
    'en': {
      'title': 'Minimalistic Push',
      'onboarding': {
        'locations': [
          'Page 1',
          'Page 2',
          'Page 3',
        ],
        'titles': [
          'Instructions',
          'Benefits',
          'Let\'s go!',
        ],
        'welcome': [
          'Welcome to',
          'The simplest push-up tracker.',
        ],
        'instructions': [
          'Record your sessions in the \'Training Mode\'.',
          'Delete previous sessions in the \'Sessions Overview\'.',
          'Watch your improvement.',
        ],
        'benefits': [
          'Track your improvement over time.',
          'Keep your data on your device.',
          'Support open-source development.',
        ]
      },
      'training': {
        'title': 'Training Mode',
        'start': 'Start',
        'alert': {
          'title': 'Wohoo!',
          'contents': [
            'It seems like your counter is already at ',
            '.',
            'Do you really want to end your session without saving?',
          ],
          'continue': 'I want to continue.',
          'end': 'I\'m done.',
        },
        'hardcore': {
          true: 'Hardcore is active.',
          false: 'Hardcore is deactivated.'
        }
      },
      'sessions': {
        'title': 'Sessions Overview',
        'empty': 'You should record a session.',
      },
      'settings': {
        'title': 'Settings',
        'themes': {
          'title': 'Themes',
          'description':
              'You can choose your preferred theme. You have a theme idea? '
                  'Check my website for instructions.',
        },
        'hardcore': {
          'title': 'Hardcore',
          'description': 'If you activate the hardcore mode, you will have to '
              'touch the screen with your nose. Otherwise, the proximity '
              'sensor of your phone will be used to determine a new push.',
        },
        'backup': {
          'title': 'Data Backup',
          'description': 'With this function of the app, you are able to '
              'export your current sessions or import old sessions. '
              'Attention: If you import old sessions, your current session '
              'will be deleted. Please export your sessions before.',
          'import': {
            'title': 'Import',
            'description': 'Do you want to continue importing your new '
                'sessions? Your current sessions will be deleted. If an '
                'error occurs, your current sessions will not be deleted.',
            'success': 'Perfect! Your new sessions should be saved '
                'in the application.',
            'fail': 'Unfortunately, something went wrong. Please make '
                'sure your copied data is in the right format.'
          },
          'export': {
            'title': 'Export',
            'success': 'Your data has been copied to your clipboard.'
          },
          'cancel': 'Cancel.',
          'okay': 'Okay.',
        },
        'about': 'About',
        'thanks': 'Thank you so much for using my app \'Minimalistic Push\'. '
            'Feel free to check out the GitHub repository.',
        'github button': 'View the source-code on GitHub.',
      },
      'share': {
        'subject': 'That\'s my Curve!',
        'text': 'Hey, check out my curve in #minimalisticpush!',
      },
    },
    'de': {
      'title': 'Minimalistic Push',
      'onboarding': {
        'locations': [
          'Seite 1',
          'Seite 2',
          'Seite 3',
        ],
        'titles': [
          'Erklärung',
          'Vorteile',
          'Los geht\'s!',
        ],
        'welcome': [
          'Willkommen bei',
          'Der einfachste Liegestütz-Tracker.',
        ],
        'instructions': [
          'Schließe Sessions im \'Trainingsmodus\' ab.',
          'Lösche vorherige Sessions im \'Sessions Überblick\'.',
          'Sieh deine Verbesserungen.',
        ],
        'benefits': [
          'Verfolge die Verbesserungen.',
          'Behalten deine Daten auf deinem Smartphone.',
          'Unterstütze open-source Entwicklung.',
        ]
      },
      'training': {
        'title': 'Trainingsmodus',
        'start': 'Start',
        'alert': {
          'title': 'Wohoo!',
          'contents': [
            'Es sieht so aus, als wäre dein Zähler schon bei ',
            '.',
            'Willst du diese Session wirklich ohne zu speichern beenden?',
          ],
          'continue': 'Ich will weitermachen.',
          'end': 'Bin fertig.',
        },
        'hardcore': {
          true: 'Hardcore ist aktiv.',
          false: 'Hardcore ist deaktiviert.'
        }
      },
      'sessions': {
        'title': 'Sessions Überblick',
        'empty': 'Du musst zuerst eine Session abschließen.',
      },
      'settings': {
        'title': 'Einstellungen',
        'themes': {
          'title': 'Themes',
          'description': 'Hier kannst du ein Theme auswählen, das dir gefällt. '
              'Du hast eine Idee für ein neues Theme? Auf meiner '
              'Internetseite kannst du dich hierzu informieren.',
        },
        'hardcore': {
          'title': 'Hardcore',
          'description': 'Bei aktiviertem Hardcore-Modus ist es nur möglich '
              'die Liegestützen per Berührung mit dem Display zu zählen. '
              'Andernfalls wird der Näherungssensor des Smartphones verwendet.',
        },
        'backup': {
          'title': 'Daten Backup',
          'description': 'Mit dieser Funktion hast du die Möglichkeit deine '
              'Sessions zu exportieren oder alte Sessions zu importieren. '
              'Achtung: Beim Import neuer Sessions werden deine aktuellen '
              'Sessions gelöscht. Bitte fertige davor ein Backup mit der '
              'Exportieren-Funktion an.',
          'import': {
            'title': 'Importieren',
            'description': 'Bist du sicher, dass du deine aktuellen Sessions '
                'löschen und neue Sessions importieren möchtest? Falls ein '
                'Fehler auftritt werden deine aktuellen Sessions natürlich '
                'nicht gelöscht.',
            'success':
                'Super! Deine neuen Daten sollten in der App gespeichert sein.',
            'fail': 'Leider ist etwas schief gelaufen. Bitte stelle sicher, '
                'dass deine Daten im richtigen Format sind.'
          },
          'export': {
            'title': 'Exportieren',
            'success': 'Deine Daten wurden in der Zwischenablage deines '
                'Smartphones zwischengespeichert.'
          },
          'cancel': 'Abbrechen.',
          'okay': 'Okay.',
        },
        'about': 'Über',
        'thanks': 'Vielen Dank, dass du meine App \'Minimalistic Push\' '
            'verwendest. Gerne kannst du dir das GitHub Repository dieser '
            'App ansehen.',
        'github button': 'Den Quellcode auf GitHub ansehen.',
      },
      'share': {
        'subject': 'Das ist meine Kurve!',
        'text': 'Hey, sieh Dir meine Kurve in #minimalisticpush an!',
      },
    },
  };

  /// Returns the localization.
  dynamic getLocale(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

/// The localizations delegate.
class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  /// The constructor.
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
