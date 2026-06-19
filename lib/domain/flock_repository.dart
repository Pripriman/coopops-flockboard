import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'flock_models.dart';

class FlockRepository extends ChangeNotifier {
  static const _flockKey = 'roost.flock';
  static const _yieldKey = 'roost.yield';
  static const _healthKey = 'roost.health';
  static const _costKey = 'roost.cost';
  static const _uuid = Uuid();

  final List<FlockEntry> _flock = [];
  final List<YieldEntry> _yield = [];
  final List<HealthEntry> _health = [];
  final List<CostEntry> _cost = [];
  bool _loaded = false;

  List<FlockEntry> get flock => List.unmodifiable(_flock);
  List<YieldEntry> get yields => List.unmodifiable(_yield);
  List<HealthEntry> get health => List.unmodifiable(_health);
  List<CostEntry> get costs => List.unmodifiable(_cost);
  bool get isLoaded => _loaded;

  int get totalBirds => _flock.fold(0, (sum, e) => sum + e.birds);
  Set<String> get uniqueBreeds =>
      _flock.map((e) => e.breedId).where((b) => b.isNotEmpty).toSet();

  int get eggsToday {
    final now = DateTime.now();
    final key =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return _yield
        .where((e) => e.dayKey == key)
        .fold(0, (sum, e) => sum + e.eggs);
  }

  int get pendingHealth => _health.where((e) => !e.done).length;

  double get monthlyCost {
    final now = DateTime.now();
    return _cost
        .where((e) => e.spentAt.year == now.year && e.spentAt.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _readList(prefs, _flockKey, _flock, FlockEntry.fromJson);
    _readList(prefs, _yieldKey, _yield, YieldEntry.fromJson);
    _readList(prefs, _healthKey, _health, HealthEntry.fromJson);
    _readList(prefs, _costKey, _cost, CostEntry.fromJson);
    _flock.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    _yield.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    _health.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    _cost.sort((a, b) => b.spentAt.compareTo(a.spentAt));
    _loaded = true;
    notifyListeners();
  }

  void _readList<T>(
    SharedPreferences prefs,
    String key,
    List<T> target,
    T Function(Map<String, dynamic>) parse,
  ) {
    target.clear();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List;
      for (final e in list) {
        target.add(parse(e as Map<String, dynamic>));
      }
    } catch (_) {}
  }

  Future<void> _persist(String key, List<dynamic> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  Future<FlockEntry> addFlock({
    required String tag,
    required String breedId,
    required String role,
    required int birds,
    required int ageWeeks,
    String note = '',
  }) async {
    final entry = FlockEntry(
      id: _uuid.v4(),
      addedAt: DateTime.now(),
      tag: tag,
      breedId: breedId,
      role: role,
      birds: birds,
      ageWeeks: ageWeeks,
      note: note,
    );
    _flock.insert(0, entry);
    await _persist(_flockKey, _flock);
    notifyListeners();
    return entry;
  }

  Future<void> removeFlock(String id) async {
    _flock.removeWhere((e) => e.id == id);
    await _persist(_flockKey, _flock);
    notifyListeners();
  }

  Future<YieldEntry> addYield({
    required DateTime loggedAt,
    required int eggs,
    int cracked = 0,
    String note = '',
  }) async {
    final entry = YieldEntry(
      id: _uuid.v4(),
      loggedAt: loggedAt,
      eggs: eggs,
      cracked: cracked,
      note: note,
    );
    _yield.insert(0, entry);
    _yield.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    await _persist(_yieldKey, _yield);
    notifyListeners();
    return entry;
  }

  Future<void> removeYield(String id) async {
    _yield.removeWhere((e) => e.id == id);
    await _persist(_yieldKey, _yield);
    notifyListeners();
  }

  Future<HealthEntry> addHealth({
    required DateTime dueAt,
    required String title,
    required String kind,
    required String coop,
  }) async {
    final entry = HealthEntry(
      id: _uuid.v4(),
      dueAt: dueAt,
      title: title,
      kind: kind,
      coop: coop,
    );
    _health.add(entry);
    _health.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    await _persist(_healthKey, _health);
    notifyListeners();
    return entry;
  }

  Future<void> toggleHealth(String id) async {
    for (final e in _health) {
      if (e.id == id) {
        e.done = !e.done;
        break;
      }
    }
    await _persist(_healthKey, _health);
    notifyListeners();
  }

  Future<void> removeHealth(String id) async {
    _health.removeWhere((e) => e.id == id);
    await _persist(_healthKey, _health);
    notifyListeners();
  }

  Future<CostEntry> addCost({
    required DateTime spentAt,
    required String category,
    required double amount,
    String note = '',
  }) async {
    final entry = CostEntry(
      id: _uuid.v4(),
      spentAt: spentAt,
      category: category,
      amount: amount,
      note: note,
    );
    _cost.insert(0, entry);
    _cost.sort((a, b) => b.spentAt.compareTo(a.spentAt));
    await _persist(_costKey, _cost);
    notifyListeners();
    return entry;
  }

  Future<void> removeCost(String id) async {
    _cost.removeWhere((e) => e.id == id);
    await _persist(_costKey, _cost);
    notifyListeners();
  }

  List<MapEntry<String, int>> recentYieldTrend(int days) {
    final out = <MapEntry<String, int>>[];
    final now = DateTime.now();
    for (var i = days - 1; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final total = _yield
          .where((e) => e.dayKey == key)
          .fold(0, (sum, e) => sum + e.eggs);
      out.add(MapEntry(key, total));
    }
    return out;
  }

  Map<String, double> costByCategory() {
    final map = <String, double>{};
    for (final e in _cost) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }
}
