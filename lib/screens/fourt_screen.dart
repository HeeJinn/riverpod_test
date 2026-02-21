import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/auth_provider.dart';
import 'package:riverpod_test/providers/shared_pref_provider.dart';

class FourtScreen extends ConsumerStatefulWidget {
  static const String routeName = '/fourth';
  const FourtScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FourtScreenState();
}

class _FourtScreenState extends ConsumerState<FourtScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isLoggedIn = ref.watch(authProvider);
    final prefs = ref.read(sharedPrefsProvider);

    Widget buildButton({
      required String label,
      required VoidCallback onPressed,
    }) {
      if (isIOS) {
        return CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onPressed: onPressed,
          child: Text(label),
        );
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        centerTitle: true,
        elevation: isIOS ? 0 : 4,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width > 800 ? width * 0.2 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Shared Preferences',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (isLoggedIn)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'Logged in',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        buildButton(
                          label: 'Save',
                          onPressed: () {
                            final username = usernameController.text.trim();
                            final password = passwordController.text.trim();
                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter username and password'),
                                ),
                              );
                              return;
                            }

                            // Use notifier to persist and update state
                            ref
                                .read(authProvider.notifier)
                                .login(username, password);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saved to SharedPreferences'),
                              ),
                            );
                          },
                        ),
                        buildButton(
                          label: 'Load',
                          onPressed: () {
                            final username = prefs.getString('username') ?? '';
                            final password = prefs.getString('password') ?? '';
                            usernameController.text = username;
                            passwordController.text = password;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Loaded from SharedPreferences'),
                              ),
                            );
                          },
                        ),
                        buildButton(
                          label: isLoggedIn ? 'Logout' : 'Clear',
                          onPressed: () {
                            if (isLoggedIn) {
                              ref.read(authProvider.notifier).logout();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out')),
                              );
                            } else {
                              prefs.remove('username');
                              prefs.remove('password');
                              usernameController.clear();
                              passwordController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cleared stored credentials'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
