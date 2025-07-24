// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'MENU';

  @override
  String get home => 'Home';

  @override
  String get myNotes => 'My Notes';

  @override
  String get mapExplorer => 'Map Explorer';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get welcomeMessage => 'Welcome to the Flutter Web App Frame!';

  @override
  String get notesDescription => 'Create, edit, and delete your personal notes. Data is saved in real-time to Firestore.';

  @override
  String get noNotes => 'No notes yet. Tap the \"+\" button to create one!';

  @override
  String get createNote => 'Create Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get mapMarkerSnippet => 'A beautiful city!';

  @override
  String get mapDescription => 'This page demonstrates the Google Maps integration.';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get profileDescription => 'This page demonstrates reading and writing data to Firestore.';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileUpdated => 'Profile Updated!';

  @override
  String get errorTitle => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get aiHelper => 'AI Helper';

  @override
  String get aiPrompt => 'AI Prompt';

  @override
  String get aiPromptHint => 'e.g., \'write a poem about Flutter\'';

  @override
  String get generateContent => 'Generate Content';

  @override
  String get signOut => 'Sign Out';
}
