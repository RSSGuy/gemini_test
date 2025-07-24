
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/core_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l10n.settings, style: Theme.of(context).textTheme.displayLarge), const SizedBox(height: 24),
      Card(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.language, style: Theme.of(context).textTheme.titleMedium,)),
            DropdownButton<Locale>(
              value: currentLocale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).state = newLocale;
                }
              },
              items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>((Locale locale) {
                final langName = locale.languageCode == 'en' ? 'English' : 'Español';
                return DropdownMenuItem<Locale>(value: locale, child: Text(langName),);
              }).toList(),
            ),
          ],
        ),
      )),
      Card(child: ListTile(leading: const Icon(Icons.notifications), title: Text(l10n.notifications), trailing: Switch(value: true, onChanged: (val) {}),),),
    ],),);
  }
}