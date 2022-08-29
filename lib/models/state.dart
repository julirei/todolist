import 'package:flutter/foundation.dart';

/// Observable state.
///
/// Can be used to wrap other models to make them
/// observable by the UI.
class State<T> extends ValueNotifier<T> {
  State(T initialValue) : super(initialValue);
}

class ComputedState<T, C> extends ValueNotifier<C> {
  ComputedState(this.baseState, this.computation, C initialState)
      : super(initialState) {
    _baseState = baseState();
    _baseState.addListener(_handleBaseStateChanged);

    // compute initial value
    _handleBaseStateChanged();
  }

  final State<T> Function() baseState;
  final C Function(T state) computation;

  late State<T> _baseState;

  @override
  void dispose() {
    _baseState.removeListener(_handleBaseStateChanged);
    super.dispose();
  }

  void _handleBaseStateChanged() {
    value = computation(_baseState.value);
  }
}
