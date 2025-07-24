import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/core_providers.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isCollapsed = ref.watch(sideMenuCollapsedProvider);
    final isMobile = MediaQuery.of(context).size.width <= 768;
    return Material(
      elevation: 4.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic,
        width: isMobile ? 250 : (isCollapsed ? 80 : 250),
        color: Theme.of(context).colorScheme.surface,
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(vertical: 16.0), alignment: Alignment.center,
            child: isMobile ? Text(l10n.menu, style: Theme.of(context).textTheme.titleLarge) : IconButton(icon: Icon(isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios), onPressed: () => ref.read(sideMenuCollapsedProvider.notifier).state = !isCollapsed,),),
          const Divider(height: 1),
          Expanded(child: ListView(children: [
            SideMenuItem(icon: Icons.home_rounded, title: l10n.home, isCollapsed: isCollapsed && !isMobile, route: '/',),
            SideMenuItem(icon: Icons.note_alt_rounded, title: l10n.myNotes, isCollapsed: isCollapsed && !isMobile, route: '/notes',),
            SideMenuItem(icon: Icons.map_rounded, title: l10n.mapExplorer, isCollapsed: isCollapsed && !isMobile, route: '/map',),
            SideMenuItem(icon: Icons.settings_rounded, title: l10n.settings, isCollapsed: isCollapsed && !isMobile, route: '/settings',),
            SideMenuItem(icon: Icons.person_rounded, title: l10n.profile, isCollapsed: isCollapsed && !isMobile, route: '/profile',),
          ],),),
        ],),
      ),
    );
  }
}

class SideMenuItem extends StatelessWidget {
  final IconData icon; final String title; final bool isCollapsed; final String route;
  const SideMenuItem({super.key, required this.icon, required this.title, required this.isCollapsed, required this.route,});
  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute == route;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(8),),
      child: Tooltip(
        message: isCollapsed ? title : '',
        // *** FIX: Wrapped the ListTile in a Builder to provide a new context. ***
        // This new context is a descendant of the Scaffold that holds the drawer,
        // allowing `Scaffold.of(newContext)` to find it successfully.
        child: Builder(
          builder: (BuildContext newContext) {
            return ListTile(
              leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),),
              title: isCollapsed ? null : Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.onSurface,),),
              onTap: () {
                // Navigate first using the original context.
                context.go(route);
                // Then, check if the drawer is open and close it using the new context.
                // Using Navigator.pop() is the standard and safest way to close a drawer.
                if (Scaffold.maybeOf(newContext)?.isDrawerOpen ?? false) {
                  Navigator.of(newContext).pop();
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
            );
          },
        ),
      ),
    );
  }
}