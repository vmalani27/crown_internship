import 'package:flutter/material.dart';
import 'package:training_app/api_helper/todo_model.dart';
import 'package:training_app/models/todo_view.dart';

class TodoCardView extends StatefulWidget {
  const TodoCardView({super.key});

  @override
  State<TodoCardView> createState() => _TodoCardViewState();
}

class _TodoCardViewState extends State<TodoCardView> {
  late Future<List<dynamic>> futureTodos;
  List<TextBody> _allTodos = [];
  List<TextBody> _filteredTodos = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSortedAscending = true;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    futureTodos = fetchPosts();
    futureTodos.then((data) {
      setState(() {
        _allTodos = data.map((todo) => TextBody.fromJson(todo)).toList();
        _filteredTodos = _allTodos;
      });
    });
    _searchController.addListener(_filterTodos);
  }

  void _filterTodos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTodos =
          _allTodos
              .where(
                (todo) =>
                    todo.title.toLowerCase().contains(query) &&
                    (_showCompleted ? todo.completed : !todo.completed),
              )
              .toList();
    });
  }

  void _sortTodos() {
    setState(() {
      _isSortedAscending = !_isSortedAscending;
      _filteredTodos.sort(
        (a, b) =>
            _isSortedAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id),
      );
    });
  }

  void _toggleFilter() {
    setState(() {
      _showCompleted = !_showCompleted;
      _filterTodos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Card View'),
        actions: [
          IconButton(
            icon: Icon(
              _isSortedAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: _sortTodos,
          ),
          IconButton(
            icon: Icon(_showCompleted ? Icons.check_circle : Icons.pending),
            onPressed: _toggleFilter,
            tooltip: _showCompleted ? 'Show Incomplete' : 'Show Completed',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Todos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_filteredTodos.isEmpty) {
                  return const Center(child: Text('No data found'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = _filteredTodos[index];
                      return Card(
                        child: ListTile(
                          title: Text('${todo.id}.${todo.title}'),
                          subtitle: Text(
                            todo.completed ? 'Completed' : 'Pending',
                            style: TextStyle(
                              color: todo.completed ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: Icon(
                            todo.completed ? Icons.check_circle : Icons.pending,
                            color: todo.completed ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
