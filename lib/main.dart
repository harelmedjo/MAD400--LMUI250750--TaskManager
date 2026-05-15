import 'package:flutter/material.dart';
import 'dart:ui';
import 'screens/task_list_screen.dart';
import 'screens/profile_screen.dart';
import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dang medjo ',
      debugShowCheckedModeBanner: false,

    
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: '.SF Pro Text',

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0A84FF),   
          secondary: Color(0xFF64D2FF), 
          surface: Color(0xFF0F172A),    
        ),

        scaffoldBackgroundColor: const Color(0xFF050816), 

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  final List<Task> _tasks = [];

  void _addOrUpdateTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      } else {
        _tasks.add(task);
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _toggleTask(Task task) {
    final toggled = task.copyWith(isCompleted: !task.isCompleted);
    _addOrUpdateTask(toggled);
  }

  void _clearAllTasks() {
    setState(() {
      _tasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TaskListScreen(
        tasks: _tasks,
        onAddTask: _addOrUpdateTask,
        onDeleteTask: _deleteTask,
        onToggleTask: _toggleTask,
        onClearAll: _clearAllTasks,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF020617), 
                  Color(0xFF0B1220), 
                  Color(0xFF0F172A), 
                ],
              ),
            ),
          ),

          Positioned(
            top: -150,
            right: -100,
            child: _buildLiquidBlob(
              600,
              const Color(0xFF0A84FF).withOpacity(0.12), // 🔵 updated
            ),
          ),

          Positioned(
            bottom: 0,
            left: -100,
            child: _buildLiquidBlob(
              500,
              const Color(0xFF64D2FF).withOpacity(0.10), // 🌊 updated
            ),
          ),

          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
        ],
      ),

      
      bottomNavigationBar: _buildAppleDock(),
    );
  }

  Widget _buildAppleDock() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 72,
            width: 240,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08), 
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.12), // softer border
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // deeper shadow
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildDockItem(0, Icons.checklist_rounded, 'Tasks'),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.08),
                ),
                _buildDockItem(1, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    // 🎨 UPDATED ACTIVE COLOR ONLY
    final Color color =
        isSelected ? const Color(0xFF0A84FF) : Colors.white70;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}