
import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.home, style: Theme.of(context).textTheme.displayLarge), const SizedBox(height: 24),
      Text(AppLocalizations.of(context)!.welcomeMessage, style: Theme.of(context).textTheme.bodyMedium,),
    ],),);
  }
}