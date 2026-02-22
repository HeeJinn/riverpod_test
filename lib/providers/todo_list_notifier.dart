import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/models/todo_model.dart';
import 'package:riverpod_test/providers/todo_repo_provider.dart';
import 'package:uuid/uuid.dart'; // Add this import
part 'todo_list_notifier.g.dart';

const _uuid = Uuid();

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  List<Todo> build() {
    final todoRepo = ref.watch(todoRepositoryProvider);
    return todoRepo.getTodos();
  }
// 2. Add parameters to match your model
  void addTodo(String title, String description) {
    // Create the new Todo object
    final newTodo = Todo(
      id: _uuid.v4(), // Quick way to generate a unique ID
      title: title,
      description: description,
      isCompleted: false, // Default value
    );

    // Optimistic Update: Update the UI immediately
    // We use the spread operator (...) to create a new list with the new item at the end
    state = [...state, newTodo];

    // Tell the repository to save it to the Hive database
    ref.read(todoRepositoryProvider).saveTodo(newTodo);
  }

  // 3. Pass the ID of the task you want to delete
  void removeTodo(String id) {
    // Optimistic Update: Filter out the deleted item and create a new list
    state = state.where((todo) => todo.id != id).toList();

    // Tell the repository to delete it from the Hive database
    ref.read(todoRepositoryProvider).deleteTodo(id);
  }

  // Bonus: You need a way to check/uncheck tasks!
  void toggleTodo(String id) {
    // Find the task, flip its boolean, and leave the others alone
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
          )
        else
          todo,
    ];

    // Find the updated task in our new state and save the change to the database
    final updatedTodo = state.firstWhere((todo) => todo.id == id);
    ref.read(todoRepositoryProvider).saveTodo(updatedTodo); 
  }
}
