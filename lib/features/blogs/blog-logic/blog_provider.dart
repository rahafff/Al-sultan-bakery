import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'blog_state_notifier.dart';

final blogNotifierProvider =
    StateNotifierProvider<BlogStateNotifier, bool>((ref) {
  return BlogStateNotifier(ref);
});
