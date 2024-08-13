import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/categories/logic/category_repo.dart';
import 'package:grocerymart/features/categories/model/category_model.dart';

class CategoryStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  CategoryStateNotifier(this.ref) : super(false);

  Future<CategoryModel> getCategories() async {
    state = true;
    try {
      final categoryResponse = await ref.read(categoryRepo).getCategories();
      state = false;
      return categoryResponse;
    } catch (error) {
      debugPrint('we have got an errors: $error');
      state = false;
      return CategoryModel(  categories: []);
    } finally {
      state = false;
    }
  }
}
