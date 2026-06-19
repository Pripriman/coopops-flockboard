import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/coop_data.dart';
import '../../domain/flock_models.dart';
import '../../domain/flock_repository.dart';
import '../../state/coop_scope.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/coop_card.dart';

class CostTrackerView extends StatelessWidget {
  const CostTrackerView({super.key});

  static const _catTints = {
    'Feed': BarnPalette.olive,
    'Water': BarnPalette.amber,
    'Power': BarnPalette.barn,
    'Bedding': BarnPalette.oliveDeep,
    'Vet': BarnPalette.watch,
  };

  Color _tint(String c) => _catTints[c] ?? BarnPalette.inkSoft;

  Future<void> _add(BuildContext context, FlockRepository repo) {
    return _openCostSheet(context, repo);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CoopScope.of(context);
    final costs = repo.costs;
    final byCat = repo.costByCategory();
    final eggsToday = repo.eggsToday;
    final perEgg = eggsToday == 0
        ? null
        : (repo.monthlyCost / 30 / eggsToday);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            CoopCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('This month', style: BarnType.label()),
                        const SizedBox(height: 6),
                        Text(
                            '\$${repo.monthlyCost.toStringAsFixed(2)}',
                            style: BarnType.readout(28,
                                color: BarnPalette.barnDeep)),
                        const SizedBox(height: 6),
                        Text(
                          perEgg == null
                              ? 'Log eggs to see cost per egg'
                              : '~\$${perEgg.toStringAsFixed(3)} per egg',
                          style: BarnType.caption(),
                        ),
                      ],
                    ),
                  ),
                  if (byCat.isNotEmpty)
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 26,
                          sections: byCat.entries.map((e) {
                            return PieChartSectionData(
                              value: e.value,
                              color: _tint(e.key),
                              radius: 18,
                              showTitle: false,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (byCat.isNotEmpty) ...[
              Text('By category', style: BarnType.label()),
              const SizedBox(height: 12),
              CoopCard(
                child: Column(
                  children: byCat.entries.map((e) {
                    final total = byCat.values.fold(0.0, (s, v) => s + v);
                    final frac = total == 0 ? 0.0 : e.value / total;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(e.key, style: BarnType.bodyStrong()),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: frac.clamp(0, 1),
                                minHeight: 9,
                                backgroundColor: BarnPalette.paperDeep,
                                color: _tint(e.key),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('\$${e.value.toStringAsFixed(0)}',
                              style: BarnType.label(color: BarnPalette.ink)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
            ],
            Text('Entries', style: BarnType.label()),
            const SizedBox(height: 12),
            if (costs.isEmpty)
              CoopCard(
                child: Row(
                  children: [
                    const Icon(Icons.payments_outlined,
                        color: BarnPalette.inkFaint),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Add feed, water, power and other costs to see your cost per bird and per egg.',
                        style: BarnType.body(),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...costs.map((e) => _costTile(repo, e)),
          ],
        ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton(
            backgroundColor: BarnPalette.barn,
            foregroundColor: Colors.white,
            onPressed: () => _add(context, repo),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }

  Widget _costTile(FlockRepository repo, CostEntry e) {
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
      onDismissed: (_) => repo.removeCost(e.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BarnPalette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BarnPalette.hairline),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tint(e.category).withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_rounded,
                  size: 20, color: _tint(e.category)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.category,
                      style: BarnType.bodyStrong(color: BarnPalette.ink)),
                  const SizedBox(height: 3),
                  Text(
                    [
                      DateFormat('MMM d, y').format(e.spentAt),
                      if (e.note.isNotEmpty) e.note,
                    ].join(' · '),
                    style: BarnType.caption(),
                  ),
                ],
              ),
            ),
            Text('\$${e.amount.toStringAsFixed(2)}',
                style: BarnType.readout(15, color: BarnPalette.barnDeep)),
          ],
        ),
      ),
    );
  }
}

Future<void> _openCostSheet(BuildContext context, FlockRepository repo) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BarnPalette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _CostSheet(repo: repo),
  );
}

class _CostSheet extends StatefulWidget {
  final FlockRepository repo;
  const _CostSheet({required this.repo});

  @override
  State<_CostSheet> createState() => _CostSheetState();
}

class _CostSheetState extends State<_CostSheet> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String _category = CoopData.costCategories.first;
  DateTime _day = DateTime.now();

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
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
    if (picked != null) setState(() => _day = picked);
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text.trim()) ?? -1;
    if (amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount.')),
      );
      return;
    }
    await widget.repo.addCost(
      spentAt: _day,
      category: _category,
      amount: amount,
      note: _note.text.trim(),
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
              Text('Add a cost', style: BarnType.title()),
              const SizedBox(height: 18),
              Text('Category', style: BarnType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: CoopData.costCategories.map((c) {
                  final sel = c == _category;
                  return ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: BarnPalette.oliveWash,
                    labelStyle: BarnType.label(
                        color: sel ? BarnPalette.ink : BarnPalette.inkSoft),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Amount', style: BarnType.label()),
              const SizedBox(height: 8),
              TextField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    hintText: '0.00', prefixText: '\$ '),
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
                      Text(DateFormat('MMM d, y').format(_day),
                          style: BarnType.bodyStrong()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Note', style: BarnType.label()),
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                decoration:
                    const InputDecoration(hintText: 'Supplier, bag count…'),
              ),
              const SizedBox(height: 22),
              ChunkyButton(label: 'Save cost', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
