import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/errors/exceptions.dart';
import '../data/user_profile_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isInitialLoading = true;
  bool _isSaving = false;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    // Wait for auth state to be potentially loaded if app starts here
    await ref.read(authStateChangesProvider.future);
    
    if (!mounted) return;
    final user = ref.read(firebaseAuthProvider).currentUser;

    if (user == null) {
      if (mounted) setState(() { _isInitialLoading = false; });
      return;
    }

    final dbService = ref.read(databaseServiceProvider); // Initialize dbService

    try {
      final profile = await dbService.getUserProfile(user.uid); // Call with user.uid
      
      if (!mounted) return;

      if (profile != null) {
        setState(() {
          _nameController.text = profile.name ?? user.displayName ?? 'Anonymous';
          _emailController.text = profile.email ?? user.email ?? 'no-email@example.com';
        });
      } else {
         setState(() {
          _nameController.text = user.displayName ?? 'Anonymous';
          _emailController.text = user.email ?? 'no-email@example.com';
        });
      }
    } on DatabaseException catch (e) {
      if (mounted) showErrorDialog(context, e.message);
    } catch (e) { // Catch any other potential errors
      if (mounted) showErrorDialog(context, "An unexpected error occurred: ${e.toString()}");
    }
    finally {
      if (mounted) setState(() { _isInitialLoading = false; });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() { _isSaving = true; });
    try {
      final dbService = ref.read(databaseServiceProvider);
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user == null) {
        return;
      }
      final updatedProfile = UserProfile(
        uid: user.uid,
        name: _nameController.text,
        email: _emailController.text,
      );
      await dbService.updateUserProfile(updatedProfile);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated,)),);
      }
    } on DatabaseException catch (e) {
      if (mounted) showErrorDialog(context, e.message);
    } finally {
      if (mounted) setState(() { _isSaving = false; });
    }
  }

  Future<void> _signOut() async {
    setState(() { _isSigningOut = true; });
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign out: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isSigningOut = false; });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateChangesProvider);
    return Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l10n.profile, style: Theme.of(context).textTheme.displayLarge), const SizedBox(height: 16),
      Text(l10n.profileDescription, style: Theme.of(context).textTheme.bodyMedium,), const SizedBox(height: 24),
      authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading auth state: ${err.toString()}')),
        data: (user) {
          if (user == null) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not signed in.'),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: () => context.go('/login'), child: const Text('Go to Login'))
              ],
            ));
          }
          if (_isInitialLoading) { return const Center(child: CircularProgressIndicator()); }
          return _buildProfileForm(user, l10n);
        },
      ),
    ],),);
  }

  Widget _buildProfileForm(User user, AppLocalizations l10n) {
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: ListView(children: [ 
      const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 60, color: Colors.white),), const SizedBox(height: 16),
      Center(child: SelectableText('User ID: ${user.uid}')), const SizedBox(height: 24),
      TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.name), readOnly: _isSaving || _isSigningOut,), const SizedBox(height: 16),
      TextField(controller: _emailController, decoration: InputDecoration(labelText: l10n.email), readOnly: true,), 
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: (_isSaving || _isSigningOut) ? null : _updateProfile,
        child: _isSaving
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,))
            : Text(l10n.saveProfile),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.errorContainer),
        onPressed: _isSigningOut || _isSaving ? null : _signOut,
        child: _isSigningOut 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(l10n.signOut, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),),
      ),
    ],),),);
  }
}
