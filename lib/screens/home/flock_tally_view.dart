import 'package:flutter/material.dart';

import '../../domain/breed_catalog.dart';
import '../../domain/coop_data.dart';
import '../../domain/flock_models.dart';
import '../../domain/flock_repository.dart';
import '../../state/coop_scope.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/coop_card.dart';
import '../../widgets/feather_mark.dart';
import '../../widgets/sensor_dial.dart';

class FlockTallyView extends StatelessWidget {
  const FlockTallyView({super.key});

  Future<void> _add(BuildContext context, FlockRepository repo) {
    return _openFlockSheet(context, repo);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CoopScope.of(context);
    final flock = repo.flock;

    return Stack(
      children: [
        if (flock.isEmpty)
          _empty(context, repo)
        else
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            children: [
              _summary(repo),
              const SizedBox(height: 18),
              Text('Batches', style: BarnType.label()),
              const SizedBox(height: 12),
              ...flock.map((e) => _flockTile(repo, e)),
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

  Widget _empty(BuildContext context, FlockRepository repo) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FeatherMark(size: 72, color: BarnPalette.olive),
            const SizedBox(height: 22),
            Text('No birds on the books yet', style: BarnType.title()),
            const SizedBox(height: 10),
            Text(
              'Add your first batch — breed, count, age and role — to start tracking the flock.',
              style: BarnType.body(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ChunkyButton(
              label: 'Add a batch',
              icon: Icons.add_rounded,
              expand: false,
              onPressed: () => _add(context, repo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(FlockRepository repo) {
    final layers = repo.flock
        .where((e) => e.role == 'Layer')
        .fold(0, (s, e) => s + e.birds);
    final progress = repo.totalBirds == 0
        ? 0.0
        : (layers / repo.totalBirds).clamp(0.0, 1.0);
    return CoopCard(
      child: Row(
        children: [
          SensorDial(
            size: 96,
            progress: progress,
            stroke: 11,
            color: BarnPalette.olive,
            track: BarnPalette.oliveWash,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${repo.totalBirds}',
                    style: BarnType.readout(24, color: BarnPalette.ink)),
                Text('birds', style: BarnType.caption()),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flock at a glance', style: BarnType.heading()),
                const SizedBox(height: 8),
                _stat('$layers laying hens', Icons.egg_alt_rounded,
                    BarnPalette.amber),
                const SizedBox(height: 4),
                _stat('${repo.flock.length} batches',
                    Icons.layers_rounded, BarnPalette.olive),
                const SizedBox(height: 4),
                _stat('${repo.uniqueBreeds.length} breeds',
                    Icons.diversity_3_rounded, BarnPalette.barn),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text,
              style: BarnType.bodyStrong(color: BarnPalette.ink),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _flockTile(FlockRepository repo, FlockEntry e) {
    final breed = BreedCatalog.byId(e.breedId);
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
      onDismissed: (_) => repo.removeFlock(e.id),
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
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: BarnPalette.oliveWash,
                shape: BoxShape.circle,
              ),
              child: const FeatherMark(size: 30, color: BarnPalette.olive),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (e.tag.isNotEmpty)
                        Text(e.tag, style: BarnType.stamp(13)),
                      if (e.tag.isNotEmpty) const SizedBox(width: 8),
                      Text(breed.label,
                          style: BarnType.bodyStrong(color: BarnPalette.olive)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${e.birds} birds · ${e.role} · ${e.ageWeeks} wk',
                    style: BarnType.caption(),
                  ),
                  if (e.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(e.note,
                        style: BarnType.body(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openFlockSheet(BuildContext context, FlockRepository repo) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BarnPalette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _FlockSheet(repo: repo),
  );
}

class _FlockSheet extends StatefulWidget {
  final FlockRepository repo;
  const _FlockSheet({required this.repo});

  @override
  State<_FlockSheet> createState() => _FlockSheetState();
}

class _FlockSheetState extends State<_FlockSheet> {
  final _tag = TextEditingController();
  final _birds = TextEditingController(text: '12');
  final _age = TextEditingController(text: '20');
  final _note = TextEditingController();
  String _breedId = BreedCatalog.all.first.id;
  String _role = CoopData.roles.first;

  @override
  void dispose() {
    _tag.dispose();
    _birds.dispose();
    _age.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final birds = int.tryParse(_birds.text.trim()) ?? 0;
    if (birds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter how many birds are in the batch.')),
      );
      return;
    }
    await widget.repo.addFlock(
      tag: _tag.text.trim(),
      breedId: _breedId,
      role: _role,
      birds: birds,
      ageWeeks: int.tryParse(_age.text.trim()) ?? 0,
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
              const _Grabber(),
              const SizedBox(height: 18),
              Text('Add a batch', style: BarnType.title()),
              const SizedBox(height: 18),
              Text('Breed', style: BarnType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: BreedCatalog.all.map((b) {
                  final sel = b.id == _breedId;
                  return GestureDetector(
                    onTap: () => setState(() => _breedId = b.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? BarnPalette.oliveWash : BarnPalette.paper,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: sel ? BarnPalette.olive : BarnPalette.hairline,
                          width: sel ? 1.6 : 1,
                        ),
                      ),
                      child: Text(b.label,
                          style: BarnType.label(
                              color:
                                  sel ? BarnPalette.oliveDeep : BarnPalette.ink)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Text('Role', style: BarnType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: CoopData.roles.map((role) {
                  final sel = role == _role;
                  return ChoiceChip(
                    label: Text(role),
                    selected: sel,
                    onSelected: (_) => setState(() => _role = role),
                    selectedColor: BarnPalette.amberWash,
                    labelStyle: BarnType.label(
                        color: sel ? BarnPalette.ink : BarnPalette.inkSoft),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _field('Batch tag', _tag, hint: 'e.g. Coop A · spring'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _field('Birds', _birds,
                        hint: '12', number: true),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _field('Age (weeks)', _age,
                        hint: '20', number: true),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _field('Note', _note, hint: 'Source, vaccination…', lines: 2),
              const SizedBox(height: 22),
              ChunkyButton(label: 'Save batch', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {String? hint, bool number = false, int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BarnType.label()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          keyboardType:
              number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: BarnPalette.hairline,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
