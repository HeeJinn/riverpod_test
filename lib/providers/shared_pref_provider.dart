import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'shared_pref_provider.g.dart';

@Riverpod(keepAlive: true)
 SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError('Preferences not initialized');
  
}