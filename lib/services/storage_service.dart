// ─── storage_service.dart ─────────────────────────────────────────────────────
// SharedPreferences wrapper for local persistence.

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _joinedGroupsKey = 'joined_groups';
  static const _lastTabKey = 'community_last_tab';

  // ── Joined groups ─────────────────────────────────────────────────────────
  Future<Set<String>> getJoinedGroups() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_joinedGroupsKey)?.toSet() ?? {};
  }

  Future<void> saveJoinedGroups(Set<String> groups) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_joinedGroupsKey, groups.toList());
  }

  // ── Last community tab ────────────────────────────────────────────────────
  Future<int> getLastCommunityTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastTabKey) ?? 0;
  }

  Future<void> saveLastCommunityTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastTabKey, index);
  }
}
