import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'details_state_notifier.dart';

final blogDetailsNotifierProvider =
    StateNotifierProvider<BlogDetailsStateNotifier, bool>((ref) {
  return BlogDetailsStateNotifier(ref);
});
