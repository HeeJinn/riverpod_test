import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/models/repository/todo_repo.dart';
part 'todo_repo_provider.g.dart';

@riverpod
 TodoRepository todoRepository(Ref ref) {
  return TodoRepository();
}