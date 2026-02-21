import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/providers/shared_pref_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  bool build() {
    // 1. READ ON STARTUP: Check if the user is already logged in
    final prefs = ref.read(sharedPrefsProvider);
    
    // If the 'username' key exists, it means they logged in previously.
    // This sets the initial state of the app to true (logged in) or false (logged out).
    return prefs.containsKey('username'); 
  }

  // 2. SAVE DATA (Login)
  void login(String username, String password) {
    final prefs = ref.read(sharedPrefsProvider);
    
    // .setString saves the text permanently to the phone
    prefs.setString('username', username);
    prefs.setString('password', password); // ⚠️ Dummy apps only!
    
    // Update the state so the UI knows we are logged in
    state = true; 
  }

  // 3. DELETE DATA (Logout)
  void logout() {
    final prefs = ref.read(sharedPrefsProvider);
    
    // .remove deletes the specific keys from the phone
    prefs.remove('username');
    prefs.remove('password');
    
    // Update the state so the UI kicks them out
    state = false;
  }
}