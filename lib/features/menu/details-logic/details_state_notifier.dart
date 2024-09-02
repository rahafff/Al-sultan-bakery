import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/menu/logic/menu_repo.dart';
import 'package:grocerymart/features/menu/model/pages_model.dart';

class PageDetailsStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  PageDetailsStateNotifier(this.ref) : super(false);

  Future<PagesModel> getPageDetails({
    required int? blogId,
  }) async {
    state = true;
    try {
      PagesModel response =
          await ref.read(menuRepo).getPageInfo( blogId);
      state = false;
      return response;
    } catch (e) {
      state = false;
      if (kDebugMode) {
        print(e);
      }
      return PagesModel(-1,'','','');
     } finally {
      state = false;
    }
  }
}
