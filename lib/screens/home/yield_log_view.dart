import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/flock_models.dart';
import '../../domain/flock_repository.dart';
import '../../state/coop_scope.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/coop_card.dart';

class YieldLogView extends StatelessWidget {
  const YieldLogView({super.key});

  Future<void> _add(BuildContext context, FlockRepository repo) {
    return _openYieldSheet(context, repo);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CoopScope.of(context);
    final yields = repo.yields;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            _summary(repo),
            const SizedBox(height: 18),
            _trendCard(repo),
            const SizedBox(height: 18),
            Text('Daily log', style: BarnType.label()),
            const SizedBox(height: 12),
            if (yields.isEmpty)
              CoopCard(
                child: Row(
                  children: [
                    const Icon(Icons.egg_outlined,
                        color: BarnPalette.inkFaint),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No collections logged yet. Tap the egg button to record today.',
                        style: BarnType.body(),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...yields.map((e) => _yieldTile(repo, e)),
          ],
        ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton(
            backgroundColor: BarnPalette.amber,
            foregroundColor: Colors.white,
            onPressed: () => _add(context, repo),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }

  Widget _summary(FlockRepository repo) {
    final trend = repo.recentYieldTrend(7);
    final weekTotal = trend.fold(0, (s, e) => s + e.value);
    final avg = trend.isEmpty ? 0 : (weekTotal / trend.length).round();
    final layers = repo.flock
        .where((e) => e.role == 'Layer')
        .fold(0, (s, e) => s + e.birds);
    final rate = layers == 0 ? 0 : ((repo.eggsToday / layers) * 100).round();
    return CoopCard(
      color: BarnPalette.amberWash,
      border: Border.all(color: BarnPalette.amber.withValues(alpha: 0.5)),
      child: Row(
        children: [
          _metric('${repo.eggsToday}', 'today'),
          _divider(),
          _metric('$avg', 'daily avg'),
          _divider(),
          _metric('$rate%', 'lay rate'),
        ],
      ),
    );
  }

  Widget _metric(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: BarnType.readout(26, color: BarnPalette.barnDeep)),
          const SizedBox(height: 4),
          Text(label, style: BarnType.caption()),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 38,
        color: BarnPalette.amber.withValues(alpha: 0.4),
      );

  Widget _trendCard(FlockRepository repo) {
    final trend = repo.recentYieldTrend(7);
    final maxY = trend.fold(0, (m, e) => e.value > m ? e.value : m);
    return CoopCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last 7 days', style: BarnType.heading()),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxY == 0 ? 10 : maxY * 1.25).toDouble(),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= trend.length) {
                          return const SizedBox.shrink();
                        }
                        final day = DateTime.parse('${trend[i].key} 00:00:00');
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(DateFormat('E').format(day)[0],
                              style: BarnType.caption()),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(trend.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: trend[i].value.toDouble(),
                        width: 16,
                        color: BarnPalette.amber,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yieldTile(FlockRepository repo, YieldEntry e) {
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
      onDismissed: (_) => repo.removeYield(e.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BarnPalette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BarnPalette.hairline),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: BarnPalette.amberWash,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.egg_alt_rounded,
                  color: BarnPalette.amber),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${e.eggs} eggs',
                      style: BarnType.bodyStrong(color: BarnPalette.ink)),
                  const SizedBox(height: 3),
                  Text(
                    [
                      DateFormat('MMM d, y').format(e.loggedAt),
                      if (e.cracked > 0) '${e.cracked} cracked',
                      if (e.note.isNotEmpty) e.note,
                    ].join(' · '),
                    style: BarnType.caption(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openYieldSheet(BuildContext context, FlockRepository repo) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BarnPalette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _YieldSheet(repo: repo),
  );
}

class _YieldSheet extends StatefulWidget {
  final FlockRepository repo;
  const _YieldSheet({required this.repo});

  @override
  State<_YieldSheet> createState() => _YieldSheetState();
}

class _YieldSheetState extends State<_YieldSheet> {
  final _eggs = TextEditingController();
  final _cracked = TextEditingController(text: '0');
  final _note = TextEditingController();
  DateTime _day = DateTime.now();

  @override
  void dispose() {
    _eggs.dispose();
    _cracked.dispose();
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
    final eggs = int.tryParse(_eggs.text.trim()) ?? -1;
    if (eggs < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter how many eggs you collected.')),
      );
      return;
    }
    await widget.repo.addYield(
      loggedAt: _day,
      eggs: eggs,
      cracked: int.tryParse(_cracked.text.trim()) ?? 0,
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
              Text('Log a collection', style: BarnType.title()),
              const SizedBox(height: 18),
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
              Row(
                children: [
                  Expanded(child: _field('Eggs', _eggs, hint: '36')),
                  const SizedBox(width: 14),
                  Expanded(child: _field('Cracked', _cracked, hint: '0')),
                ],
              ),
              const SizedBox(height: 14),
              _field('Note', _note,
                  hint: 'Coop A short, weather…', lines: 2, number: false),
              const SizedBox(height: 22),
              ChunkyButton(label: 'Save collection', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {String? hint, bool number = true, int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BarnType.label()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
