import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../l10n/app_localizations.dart';
import 'side_menu.dart';

/*
class AppScaffold extends ConsumerWidget {
  final Widget child;
  const AppScaffold({required this.child, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Row(children: [const SideMenu(), Expanded(child: Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard), automaticallyImplyLeading: false,), body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: child,),),),],);
        } else {
          return Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard),), drawer: const SideMenu(), body: child,);
        }
      },
    );
  }
}*/

// *** FIX: Changed from ConsumerWidget to StatelessWidget to resolve type error. ***
// This widget doesn't need to listen to providers, so StatelessWidget is more appropriate
// and resolves the static analysis error reported by the router.
class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({required this.child, super.key});
  @override
  Widget build(BuildContext context) { // Removed the 'ref' parameter
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Row(children: [const SideMenu(), Expanded(child: Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard), automaticallyImplyLeading: false,), body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: child,),),),],);
        } else {
          return Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard),), drawer: const SideMenu(), body: child,);
        }
      },
    );
  }
}