import 'dart:math' as math;

class SensorReading {
  final String id;
  final String label;
  final String unit;
  final double value;
  final double min;
  final double max;
  final double lowOk;
  final double highOk;
  final String coop;

  const SensorReading({
    required this.id,
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.lowOk,
    required this.highOk,
    required this.coop,
  });

  double get fraction {
    final span = max - min;
    if (span <= 0) return 0;
    return ((value - min) / span).clamp(0.0, 1.0);
  }

  bool get inRange => value >= lowOk && value <= highOk;

  String get status {
    if (inRange) return 'Normal';
    return value < lowOk ? 'Low' : 'High';
  }
}

class CoopData {
  static const coops = ['Coop A', 'Coop B', 'Brooder', 'Range'];

  static const roles = ['Layer', 'Broiler', 'Breeder', 'Cull'];

  static const costCategories = ['Feed', 'Water', 'Power', 'Bedding', 'Vet'];

  static const healthKinds = ['Vaccine', 'Symptom', 'Quarantine', 'Treatment'];

  static List<SensorReading> sensors(int seed) {
    final r = math.Random(seed);
    double jitter(double base, double spread) =>
        base + (r.nextDouble() - 0.5) * spread;
    return [
      SensorReading(
        id: 'temp_a',
        label: 'Temperature · Coop A',
        unit: '°C',
        value: double.parse(jitter(21, 8).toStringAsFixed(1)),
        min: 0,
        max: 40,
        lowOk: 16,
        highOk: 26,
        coop: 'Coop A',
      ),
      SensorReading(
        id: 'humid_a',
        label: 'Humidity · Coop A',
        unit: '%',
        value: double.parse(jitter(58, 24).toStringAsFixed(0)),
        min: 0,
        max: 100,
        lowOk: 45,
        highOk: 70,
        coop: 'Coop A',
      ),
      SensorReading(
        id: 'ammonia',
        label: 'Ammonia · Coop B',
        unit: 'ppm',
        value: double.parse(jitter(14, 18).toStringAsFixed(0)),
        min: 0,
        max: 50,
        lowOk: 0,
        highOk: 20,
        coop: 'Coop B',
      ),
      SensorReading(
        id: 'feeder',
        label: 'Feeder level · Coop B',
        unit: '%',
        value: double.parse(jitter(62, 60).clamp(0, 100).toStringAsFixed(0)),
        min: 0,
        max: 100,
        lowOk: 25,
        highOk: 100,
        coop: 'Coop B',
      ),
      SensorReading(
        id: 'water',
        label: 'Water flow · Range',
        unit: 'L/h',
        value: double.parse(jitter(7.5, 9).clamp(0, 20).toStringAsFixed(1)),
        min: 0,
        max: 20,
        lowOk: 3,
        highOk: 16,
        coop: 'Range',
      ),
      SensorReading(
        id: 'brooder',
        label: 'Brooder heat',
        unit: '°C',
        value: double.parse(jitter(33, 8).toStringAsFixed(1)),
        min: 20,
        max: 40,
        lowOk: 30,
        highOk: 35,
        coop: 'Brooder',
      ),
    ];
  }
}
