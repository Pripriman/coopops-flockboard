import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/coop_data.dart';
import '../../domain/flock_models.dart';
import '../../domain/flock_repository.dart';
import '../../state/coop_scope.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/coop_card.dart';

class HealthBoardView extends StatelessWidget {
  const HealthBoardView({super.key});

  Future<void> _add(BuildContext context, FlockRepository repo) {
    return _openHealthSheet(context, repo);
  }

  Color _kindTint(String kind) {
    switch (kind) {
      case 'Vaccine':
        return BarnPalette.olive;
      case 'Symptom':
        return BarnPalette.watch;
      case 'Quarantine':
        return BarnPalette.barn;
      default:
        return BarnPalette.amber;
    }
  }

  IconData _kindIcon(String kind) {
    switch (kind) {
      case 'Vaccine':
        return Icons.vaccines_rounded;
      case 'Symptom':
        return Icons.sick_rounded;
      case 'Quarantine':
        return Icons.shield_rounded;
      default:
        return Icons.medical_services_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = CoopScope.of(context);
    final tasks = repo.health;
    final now = DateTime.now();

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            CoopCard(
              color: BarnPalette.oliveWash,
              border: Border.all(color: BarnPalette.olive.withValues(alpha: 0.4)),
              child: Row(
                children: [
                  const Icon(Icons.event_available_rounded,
                      color: BarnPalette.oliveDeep),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      repo.pendingHealth == 0
                          ? 'No open health tasks. The flock is on schedule.'
                          : '${repo.pendingHealth} open task(s) — keep vaccinations and checks on time.',
                      style: BarnType.bodyStrong(color: BarnPalette.ink),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('Schedule', style: BarnType.label()),
            const SizedBox(height: 12),
            if (tasks.isEmpty)
              CoopCard(
                child: Row(
                  children: [
                    const Icon(Icons.health_and_safety_outlined,
                        color: BarnPalette.inkFaint),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Add a vaccination, symptom note or quarantine flag to start the health board.',
                        style: BarnType.body(),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...tasks.map((e) => _healthTile(repo, e, now)),
          ],
        ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton(
            backgroundColor: BarnPalette.olive,
            foregroundColor: Colors.white,
            onPressed: () => _add(context, repo),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }

  Widget _healthTile(FlockRepository repo, HealthEntry e, DateTime now) {
    final overdue = !e.done && e.dueAt.isBefore(now);
    final tint = _kindTint(e.kind);
    return Dismissible(
      key: ValueKey(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: BarnPalette.barnWash,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            const Icon(Icons.delete_outline_rounded, color: BarnPalette.barn),
      ),
      onDismissed: (_) => repo.removeHealth(e.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BarnPalette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: overdue ? BarnPalette.barn : BarnPalette.hairline),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => repo.toggleHealth(e.id),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: e.done
                      ? BarnPalette.healthy.withValues(alpha: 0.16)
                      : tint.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  e.done ? Icons.check_rounded : _kindIcon(e.kind),
                  color: e.done ? BarnPalette.healthy : tint,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title.isEmpty ? e.kind : e.title,
                    style: BarnType.bodyStrong(
                      color: e.done ? BarnPalette.inkFaint : BarnPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      e.kind,
                      if (e.coop.isNotEmpty) e.coop,
                      DateFormat('MMM d').format(e.dueAt),
                    ].join(' · '),
                    style: BarnType.caption(
                      color: overdue ? BarnPalette.barn : BarnPalette.inkFaint,
                    ),
                  ),
                ],
              ),
            ),
            if (overdue)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: BarnPalette.barnWash,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Overdue',
                    style: BarnType.label(color: BarnPalette.barn)),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openHealthSheet(BuildContext context, FlockRepository repo) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BarnPalette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _HealthSheet(repo: repo),
  );
}

class _HealthSheet extends StatefulWidget {
  final FlockRepository repo;
  const _HealthSheet({required this.repo});

  @override
  State<_HealthSheet> createState() => _HealthSheetState();
}

class _HealthSheetState extends State<_HealthSheet> {
  final _title = TextEditingController();
  String _kind = CoopData.healthKinds.first;
  String _coop = CoopData.coops.first;
  DateTime _due = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: BarnPalette.olive,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    await widget.repo.addHealth(
      dueAt: _due,
      title: _title.text.trim(),
      kind: _kind,
      coop: _coop,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: BarnPalette.hairline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('New health task', style: BarnType.title()),
              const SizedBox(height: 18),
              Text('Type', style: BarnType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: CoopData.healthKinds.map((k) {
                  final sel = k == _kind;
                  return ChoiceChip(
                    label: Text(k),
                    selected: sel,
                    onSelected: (_) => setState(() => _kind = k),
                    selectedColor: BarnPalette.oliveWash,
                    labelStyle: BarnType.label(
                        color: sel ? BarnPalette.ink : BarnPalette.inkSoft),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Title', style: BarnType.label()),
              const SizedBox(height: 8),
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                    hintText: 'e.g. Newcastle booster'),
              ),
              const SizedBox(height: 16),
              Text('Coop', style: BarnType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: CoopData.coops.map((c) {
                  final sel = c == _coop;
                  return ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    onSelected: (_) => setState(() => _coop = c),
                    selectedColor: BarnPalette.amberWash,
                    labelStyle: BarnType.label(
                        color: sel ? BarnPalette.ink : BarnPalette.inkSoft),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    color: BarnPalette.paper,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BarnPalette.hairline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_rounded,
                          size: 18, color: BarnPalette.olive),
                      const SizedBox(width: 8),
                      Text('Due ${DateFormat('MMM d, y').format(_due)}',
                          style: BarnType.bodyStrong()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ChunkyButton(label: 'Save task', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
