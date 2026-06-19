class FlockEntry {
  final String id;
  DateTime addedAt;
  String tag;
  String breedId;
  String role;
  int birds;
  int ageWeeks;
  String note;

  FlockEntry({
    required this.id,
    required this.addedAt,
    required this.tag,
    required this.breedId,
    required this.role,
    required this.birds,
    required this.ageWeeks,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'addedAt': addedAt.toIso8601String(),
        'tag': tag,
        'breed': breedId,
        'role': role,
        'birds': birds,
        'ageWeeks': ageWeeks,
        'note': note,
      };

  static FlockEntry fromJson(Map<String, dynamic> j) => FlockEntry(
        id: j['id'] as String,
        addedAt: DateTime.parse(j['addedAt'] as String),
        tag: j['tag'] as String? ?? '',
        breedId: j['breed'] as String? ?? '',
        role: j['role'] as String? ?? 'Layer',
        birds: j['birds'] as int? ?? 0,
        ageWeeks: j['ageWeeks'] as int? ?? 0,
        note: j['note'] as String? ?? '',
      );
}

class YieldEntry {
  final String id;
  DateTime loggedAt;
  int eggs;
  int cracked;
  String note;

  YieldEntry({
    required this.id,
    required this.loggedAt,
    required this.eggs,
    this.cracked = 0,
    this.note = '',
  });

  String get dayKey =>
      '${loggedAt.year}-${loggedAt.month.toString().padLeft(2, '0')}-${loggedAt.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'loggedAt': loggedAt.toIso8601String(),
        'eggs': eggs,
        'cracked': cracked,
        'note': note,
      };

  static YieldEntry fromJson(Map<String, dynamic> j) => YieldEntry(
        id: j['id'] as String,
        loggedAt: DateTime.parse(j['loggedAt'] as String),
        eggs: j['eggs'] as int? ?? 0,
        cracked: j['cracked'] as int? ?? 0,
        note: j['note'] as String? ?? '',
      );
}

class HealthEntry {
  final String id;
  DateTime dueAt;
  String title;
  String kind;
  String coop;
  bool done;

  HealthEntry({
    required this.id,
    required this.dueAt,
    required this.title,
    required this.kind,
    required this.coop,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dueAt': dueAt.toIso8601String(),
        'title': title,
        'kind': kind,
        'coop': coop,
        'done': done,
      };

  static HealthEntry fromJson(Map<String, dynamic> j) => HealthEntry(
        id: j['id'] as String,
        dueAt: DateTime.parse(j['dueAt'] as String),
        title: j['title'] as String? ?? '',
        kind: j['kind'] as String? ?? 'Vaccine',
        coop: j['coop'] as String? ?? '',
        done: j['done'] as bool? ?? false,
      );
}

class CostEntry {
  final String id;
  DateTime spentAt;
  String category;
  double amount;
  String note;

  CostEntry({
    required this.id,
    required this.spentAt,
    required this.category,
    required this.amount,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'spentAt': spentAt.toIso8601String(),
        'category': category,
        'amount': amount,
        'note': note,
      };

  static CostEntry fromJson(Map<String, dynamic> j) => CostEntry(
        id: j['id'] as String,
        spentAt: DateTime.parse(j['spentAt'] as String),
        category: j['category'] as String? ?? 'Feed',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        note: j['note'] as String? ?? '',
      );
}
