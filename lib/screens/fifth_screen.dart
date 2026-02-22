import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/todo_list_notifier.dart';

class FifthScreen extends ConsumerStatefulWidget {
  static const routeName = '/fifth';
  const FifthScreen({super.key});

  @override
  ConsumerState<FifthScreen> createState() => _FifthScreenState();
}

class _FifthScreenState extends ConsumerState<FifthScreen> {
  // This is the function that builds and shows the dialog
  void _showAddTodoDialog() {
    // 1. We create controllers to grab the text the user types
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    // 2. showDialog is a built-in Flutter function that dims the screen and pops up a box
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Shrinks the column to fit the text fields
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Buy groceries',
                ),
                autofocus: true, // Automatically pops up the keyboard!
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Milk, Eggs, Bread',
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context), // Closes the dialog
              child: const Text('Cancel'),
            ),
            // Add Button
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                // Simple validation: Don't add if the title is empty
                if (title.isNotEmpty) {
                  // 3. READ the notifier and fire off the addTodo method!
                  ref
                      .read(todoListProvider.notifier)
                      .addTodo(title, description);

                  // 4. Close the dialog
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Task'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TodoList'), centerTitle: true),

      body: Consumer(
        builder: (context, ref, _) {
          final todos = ref.watch(todoListProvider);

          if (todos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.inbox, size: 72, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No tasks yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap + to add your first task',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger a refresh of the provider state if needed.
              try {
                ref.invalidate(todoListProvider);
              } catch (_) {}
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return Dismissible(
                  key: Key(todo.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(todoListProvider.notifier).removeTodo(todo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted')),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => ref
                            .read(todoListProvider.notifier)
                            .toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: todo.description.isNotEmpty
                          ? Text(todo.description)
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref
                            .read(todoListProvider.notifier)
                            .removeTodo(todo.id),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.large(
        // Hook up the FAB to our new dialog function
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
