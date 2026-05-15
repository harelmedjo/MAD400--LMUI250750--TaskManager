import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(String) onDeleteTask;
  final Function(Task) onToggleTask;
  final VoidCallback onClearAll;

  const TaskListScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onDeleteTask,
    required this.onToggleTask,
    required this.onClearAll,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _filter = 'All';
  final String _sortBy = 'Date';
  String _searchQuery = '';
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _newDueDate = DateTime.now().add(const Duration(days: 1));
  String _newCategory = 'General';
  String _newPriority = 'Medium';

  // 🎨 PREMIUM COLOR SYSTEM (Deep Indigo + Electric Cyan)
  static const Color primary = Color.fromARGB(255, 1, 0, 10);
  static const Color accent = Color.fromARGB(230, 55, 143, 163);
  static const Color done = Color.fromARGB(255, 1, 66, 25);
  static const Color warning = Color.fromARGB(255, 205, 207, 207);
  static const Color danger = Color.fromARGB(255, 107, 4, 4);

  List<Task> get _filteredTasks {
    List<Task> filtered = List.from(widget.tasks);

    if (_filter == 'Pending') {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_sortBy == 'Date') {
      filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks;
    final total = widget.tasks.length;
    final doneTasks = widget.tasks.where((t) => t.isCompleted).length;
    final pending = total - doneTasks;
    final progress = total == 0 ? 0.0 : doneTasks / total;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF050612),

      // 🌌 APP BAR PREMIUM
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              title: const Text(
                "Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      _searchQuery = "";
                      _searchController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 🌌 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 0, 0, 19),
                  Color.fromARGB(255, 0, 6, 19),
                  Color.fromARGB(255, 62, 62, 141),
                  Color.fromARGB(255, 34, 45, 102),
                ],
              ),
            ),
          ),

          // ✨ GLOW
          Positioned(
            top: -120,
            right: -80,
            child: _glow(300, const Color.fromARGB(255, 57, 42, 223).withValues(alpha: 0.22)),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _glow(320, accent.withValues(alpha: 0.22)),
          ),

          ListView(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 120),
            children: [
              _buildStats(progress, total, doneTasks, pending),

              const SizedBox(height: 16),

              _buildFilters(),

              const SizedBox(height: 10),

              if (tasks.isEmpty)
                _empty()
              else
                ...tasks.map(
                  (task) => _taskTile(task),
                ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: _showCreateTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _newDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _newDueDate = picked;
      });
    }
  }

  Future<void> _showCreateTaskDialog() async {
    _titleController.clear();
    _descController.clear();
    _newDueDate = DateTime.now().add(const Duration(days: 1));
    _newCategory = 'General';
    _newPriority = 'Medium';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111827),
          title: const Text('Create Task', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _newCategory,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: ['General', 'Work', 'Personal']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _newCategory = v ?? 'General'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _newPriority,
                        decoration: const InputDecoration(labelText: 'Priority'),
                        items: ['Low', 'Medium', 'High']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => _newPriority = v ?? 'Medium'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Due: ${_newDueDate.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _pickDueDate(context),
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final desc = _descController.text.trim();

                if (title.isEmpty) return;

                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  description: desc,
                  category: _newCategory,
                  priority: _newPriority,
                  dueDate: _newDueDate,
                );

                widget.onAddTask(task);
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // 📊 STATS CARD
  Widget _buildStats(double progress, int total, int done, int pending) {
    return _glass(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat("$total", "Total"),
              _stat("$done", "Done",),
              _stat("$pending", "Pending", warning),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: primary,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toInt()}% Completed",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          )
        ],
      ),
    );
  }

  Widget _stat(String v, String l, [Color? c]) {
    return Column(
      children: [
        Text(
          v,
          style: TextStyle(
            color: c ?? Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          l,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  // 🧊 GLASS CARD
  Widget _glass({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // 🔘 FILTERS
  Widget _buildFilters() {
    final items = ["All", "Pending", "Completed"];

    return Row(
      children: items.map((f) {
        final selected = _filter == f;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? primary.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: selected ? primary : Colors.white70,
                  fontWeight:
                      selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🧾 TASK TILE
  Widget _taskTile(Task task) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: () => widget.onToggleTask(task),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? done : warning,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline, color: danger),
              onPressed: () => widget.onDeleteTask(task.id),
            ),
          ],
        ),
      ),
    );
  }

  // 🌌 EMPTY STATE
  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.white.withValues(alpha: 0.1)),
            const SizedBox(height: 10),
            Text(
              "No tasks yet",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
        child: const SizedBox(),
      ),
    );
  }
}