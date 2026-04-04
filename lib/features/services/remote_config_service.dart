import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteConfigService {
  final _rc = FirebaseRemoteConfig.instance;

  Future<void> initialise() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _rc.setDefaults({'gemini_api_key': ''});
    await _rc.fetchAndActivate();
  }

  String get geminiApiKey => _rc.getString('gemini_api_key');
}

final remoteConfigServiceProvider = Provider<RemoteConfigService>(
  (ref) => RemoteConfigService(),
);
