import 'package:hive_ce/hive.dart';
import 'package:riverpod_test/models/todo_model.dart';
import 'package:flutter/foundation.dart';

class TodoRepository {
  Box<Todo>? get _box {
    try {
      // Only return the box if it's already open to avoid synchronous exceptions
      if (Hive.isBoxOpen('todoBox')) {
        return Hive.box<Todo>('todoBox');
      }
    } catch (_) {}
    return null;
  }

  List<Todo> getTodos() {
    try {
      final list = _box?.values.toList() ?? [];
      if (_box == null) {
        debugPrint(
          'TodoRepository.getTodos: box not open, returning empty list',
        );
      } else {
        debugPrint('TodoRepository.getTodos: loaded ${list.length} todos');
      }
      return list;
    } catch (e, st) {
      debugPrint('TodoRepository.getTodos error: $e\n$st');
      return [];
    }
  }

  Future<void> saveTodo(Todo todo) async {
    final box = _box;
    if (box == null) {
      debugPrint(
        'TodoRepository.saveTodo: box not open — skipping save for ${todo.id}',
      );
      return;
    }
    try {
      await box.put(todo.id, todo);
      debugPrint('TodoRepository.saveTodo: saved ${todo.id}');
    } catch (e, st) {
      debugPrint('TodoRepository.saveTodo error: $e\n$st');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    final box = _box;
    if (box == null) {
      debugPrint(
        'TodoRepository.deleteTodo: box not open — skipping delete for $id',
      );
      return;
    }
    try {
      await box.delete(id);
      debugPrint('TodoRepository.deleteTodo: deleted $id');
    } catch (e, st) {
      debugPrint('TodoRepository.deleteTodo error: $e\n$st');
    }
  }
}
