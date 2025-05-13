import 'package:flutter/material.dart';
import 'package:training_app_2/api/todo_model.dart';
import 'package:training_app_2/models/todo_view.dart';

class TodoCardView extends StatefulWidget {
  const TodoCardView({super.key});

  @override
  State<TodoCardView> createState() => _TodoCardViewState();
}

class _TodoCardViewState extends State<TodoCardView> {
  late Future<List<dynamic>> futureTodos;

  @override
  void initState() {
    super.initState();
    futureTodos = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Card View'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final List<dynamic> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                try {
                  final todo = todos[index];
                  final todoView = TextBody.fromJson(todo);
                  final title = todoView.title;
                  final completed = todoView.completed;

                  return Card(
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(
                        completed ? 'Completed' : 'Pending',
                        style: TextStyle(
                          color: completed ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: Icon(
                        completed ? Icons.check_circle : Icons.pending,
                        color: completed ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                } catch (e) {
                  return ListTile(
                    title: const Text('Error loading todo'),
                    subtitle: Text(e.toString()),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}