import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'details_state_notifier.dart';

final PageDetailsNotifierProvider =
    StateNotifierProvider<PageDetailsStateNotifier, bool>((ref) {
  return PageDetailsStateNotifier(ref);
});
