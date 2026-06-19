class BreedType {
  final String id;
  final String label;
  final String origin;
  final String purpose;
  final int eggsPerYear;
  final String eggColor;
  final String temperament;
  final String keeperTip;

  const BreedType({
    required this.id,
    required this.label,
    required this.origin,
    required this.purpose,
    required this.eggsPerYear,
    required this.eggColor,
    required this.temperament,
    required this.keeperTip,
  });
}

class BreedCatalog {
  static const List<BreedType> all = [
    BreedType(
      id: 'isabrown',
      label: 'ISA Brown',
      origin: 'France',
      purpose: 'Layer',
      eggsPerYear: 320,
      eggColor: 'Brown',
      temperament: 'Calm, docile',
      keeperTip:
          'A reliable commercial layer that starts early and keeps up output through winter. Watch nutrition closely — heavy laying drains calcium fast.',
    ),
    BreedType(
      id: 'leghorn',
      label: 'White Leghorn',
      origin: 'Italy',
      purpose: 'Layer',
      eggsPerYear: 300,
      eggColor: 'White',
      temperament: 'Active, flighty',
      keeperTip:
          'Light, efficient feeders that turn out large white eggs. They roost high and fly well, so give the run good height and secure netting.',
    ),
    BreedType(
      id: 'rir',
      label: 'Rhode Island Red',
      origin: 'United States',
      purpose: 'Dual purpose',
      eggsPerYear: 260,
      eggColor: 'Brown',
      temperament: 'Hardy, assertive',
      keeperTip:
          'Tough all-rounder that lays steadily and tolerates cold. Dominant roosters can be pushy — keep an eye on flock pecking order.',
    ),
    BreedType(
      id: 'orpington',
      label: 'Buff Orpington',
      origin: 'England',
      purpose: 'Dual purpose',
      eggsPerYear: 200,
      eggColor: 'Brown',
      temperament: 'Gentle, broody',
      keeperTip:
          'Big, fluffy and friendly — great for mixed flocks. Goes broody readily, so collect eggs often if you are not hatching.',
    ),
    BreedType(
      id: 'plymouth',
      label: 'Plymouth Rock',
      origin: 'United States',
      purpose: 'Dual purpose',
      eggsPerYear: 220,
      eggColor: 'Brown',
      temperament: 'Friendly, robust',
      keeperTip:
          'Barred plumage and a steady nature make this a beginner favourite. Forages well and handles confinement without fuss.',
    ),
    BreedType(
      id: 'sussex',
      label: 'Speckled Sussex',
      origin: 'England',
      purpose: 'Dual purpose',
      eggsPerYear: 240,
      eggColor: 'Cream',
      temperament: 'Curious, calm',
      keeperTip:
          'Alert foragers that keep laying in cooler months. The speckling deepens with each moult, so older hens look richer.',
    ),
    BreedType(
      id: 'australorp',
      label: 'Australorp',
      origin: 'Australia',
      purpose: 'Layer',
      eggsPerYear: 280,
      eggColor: 'Brown',
      temperament: 'Quiet, gentle',
      keeperTip:
          'Record-setting brown-egg layers with glossy black feathers. Heat-tolerant and undemanding — a strong choice for steady supply.',
    ),
    BreedType(
      id: 'marans',
      label: 'Cuckoo Marans',
      origin: 'France',
      purpose: 'Layer',
      eggsPerYear: 180,
      eggColor: 'Dark chocolate',
      temperament: 'Calm, hardy',
      keeperTip:
          'Famous for deep mahogany eggs. Output is moderate but the colour is a market draw — keep nest boxes clean to show it off.',
    ),
    BreedType(
      id: 'wyandotte',
      label: 'Silver Wyandotte',
      origin: 'United States',
      purpose: 'Dual purpose',
      eggsPerYear: 200,
      eggColor: 'Brown',
      temperament: 'Calm, cold-hardy',
      keeperTip:
          'Rose comb resists frostbite, so this breed thrives in cold barns. Dense plumage means good winter laying with proper light.',
    ),
    BreedType(
      id: 'silkie',
      label: 'Silkie',
      origin: 'China',
      purpose: 'Ornamental',
      eggsPerYear: 120,
      eggColor: 'Cream',
      temperament: 'Docile, broody',
      keeperTip:
          'Fluffy and friendly but a poor flyer and weak layer. Excellent natural mother — often used to hatch other breeds eggs.',
    ),
    BreedType(
      id: 'brahma',
      label: 'Light Brahma',
      origin: 'United States',
      purpose: 'Dual purpose',
      eggsPerYear: 150,
      eggColor: 'Brown',
      temperament: 'Gentle giant',
      keeperTip:
          'Feathered feet and a heavy frame make this a calm, cold-hardy bird. Slow to mature but lays well through the coldest months.',
    ),
    BreedType(
      id: 'ameraucana',
      label: 'Ameraucana',
      origin: 'United States',
      purpose: 'Layer',
      eggsPerYear: 200,
      eggColor: 'Blue',
      temperament: 'Alert, hardy',
      keeperTip:
          'Lays striking blue eggs and sports muffs and a beard. Active foragers that handle cold well — give them room to roam.',
    ),
  ];

  static BreedType byId(String id) =>
      all.firstWhere((b) => b.id == id, orElse: () => all.first);
}
