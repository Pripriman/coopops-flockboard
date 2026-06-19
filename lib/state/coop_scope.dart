import 'package:flutter/widgets.dart';
import '../domain/flock_repository.dart';

class CoopScope extends InheritedNotifier<FlockRepository> {
  const CoopScope({
    super.key,
    required FlockRepository ledger,
    required super.child,
  }) : super(notifier: ledger);

  static FlockRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CoopScope>();
    assert(scope != null, 'CoopScope not found in context');
    return scope!.notifier!;
  }

  static FlockRepository read(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<CoopScope>()
        ?.widget as CoopScope?;
    return scope!.notifier!;
  }
}
