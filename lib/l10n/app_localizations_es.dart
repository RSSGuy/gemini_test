// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get dashboard => 'Tablero';

  @override
  String get menu => 'MENÚ';

  @override
  String get home => 'Inicio';

  @override
  String get myNotes => 'Mis Notas';

  @override
  String get mapExplorer => 'Explorador de Mapas';

  @override
  String get settings => 'Ajustes';

  @override
  String get profile => 'Perfil';

  @override
  String get welcomeMessage => '¡Bienvenido al Marco de Aplicación Web de Flutter!';

  @override
  String get notesDescription => 'Crea, edita y elimina tus notas personales. Los datos se guardan en tiempo real en Firestore.';

  @override
  String get noNotes => 'Aún no hay notas. ¡Toca el botón \"+\" para crear una!';

  @override
  String get createNote => 'Crear Nota';

  @override
  String get editNote => 'Editar Nota';

  @override
  String get title => 'Título';

  @override
  String get content => 'Contenido';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get mapMarkerSnippet => '¡Una ciudad hermosa!';

  @override
  String get mapDescription => 'Esta página demuestra la integración de Google Maps.';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get profileDescription => 'Esta página demuestra la lectura y escritura de datos en Firestore.';

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get saveProfile => 'Guardar Perfil';

  @override
  String get profileUpdated => '¡Perfil Actualizado!';

  @override
  String get errorTitle => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get aiHelper => 'Asistente de IA';

  @override
  String get aiPrompt => 'Instrucción para IA';

  @override
  String get aiPromptHint => 'ej. \'escribe un poema sobre Flutter\'';

  @override
  String get generateContent => 'Generar Contenido';

  @override
  String get signOut => 'Cerrar sesión';
}
