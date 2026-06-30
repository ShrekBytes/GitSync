import 'dart:async';
import 'package:GitSync/api/manager/settings_manager.dart';
import 'package:GitSync/api/manager/storage.dart';
import 'package:GitSync/global.dart';
import 'package:flutter/foundation.dart';

// INTERNAL / TEAM TESTING BUILD ONLY.
// Premium is always unlocked here. Do NOT submit this file's build to app stores.
class PremiumManager {
  final ValueNotifier<bool?> hasPremiumNotifier = ValueNotifier(true);

  Future<void> init() async {
    hasPremiumNotifier.value = true;
  }

  Future<void> updateGitHubSponsorPremium() async {
    // No-op in the internal build — premium is always on, nothing to check.
  }

  Future<bool> cullNonPremium() async {
    final repomanReponames = await repoManager.getStringList(StorageKey.repoman_repoNames);
    if (repomanReponames.length > 1) {
      List.generate(repomanReponames.length - 1, (index) async {
        final manager = await SettingsManager().reinit(repoIndex: 1 + index);
        await manager.clearAll();
      });
      await repoManager.setInt(StorageKey.repoman_repoIndex, 0);
      await repoManager.setStringList(StorageKey.repoman_repoNames, [repomanReponames[0]]);
      return true;
    }
    return false;
  }

  void dispose() async {
    hasPremiumNotifier.dispose();
  }
}
