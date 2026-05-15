import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  // 🎨 PREMIUM COLOR SYSTEM (Deep Indigo + Electric Cyan)
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFF00D2FF);
  static const Color success = Color(0xFF4ADE80);
  static const Color danger = Color(0xFFFF6B6B);

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final completed = task.isCompleted;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF050612),

      // 🌌 APP BAR PREMIUM
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              title: const Text(
                "Task Details",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              leading: _iconBtn(Icons.arrow_back_ios_new_rounded, () {
                Navigator.pop(context);
              }),
              actions: [
                _iconBtn(Icons.edit_rounded, () {
                  onEdit();
                  Navigator.pop(context);
                }, primary),
                const SizedBox(width: 8),
                _iconBtn(Icons.delete_outline_rounded, () {
                  _showDeleteDialog(context);
                }, danger),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 🌌 BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF050612),
                  Color(0xFF0C1220),
                  Color(0xFF111A2C),
                  Color(0xFF090C18),
                ],
              ),
            ),
          ),
          

          // ✨ GLOW EFFECTS
          Positioned(
            top: -120,
            right: -100,
            child: _glow(280, primary.withValues(alpha: 0.25)),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: _glow(300, secondary.withValues(alpha: 0.18)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: completed
                                      ? [success, success.withValues(alpha: 0.6)]
                                      : [primary, secondary],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (completed ? success : primary)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                completed
                                    ? Icons.check_rounded
                                    : Icons.task_alt_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  decoration: completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor:
                                      Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        _divider(),

                        const SizedBox(height: 22),

                        _infoTile(
                          icon: Icons.description,
                          title: "DESCRIPTION",
                          value: task.description,
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: _miniCard(
                                icon: Icons.folder,
                                label: "CATEGORY",
                                value: task.category,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _miniCard(
                                icon: Icons.flag,
                                label: "PRIORITY",
                                value: task.priority,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        _infoTile(
                          icon: Icons.calendar_month,
                          title: "DUE DATE",
                          value: _formatDate(task.dueDate),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        onToggle();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: completed
                              ? Colors.white.withValues(alpha: 0.08)
                            : primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        completed
                            ? "Mark as Pending"
                            : "Mark as Completed",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧊 GLASS CARD
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // 📌 INFO TILE
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primary, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🧩 MINI CARD
  Widget _miniCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: secondary, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, [Color? color]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.06),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 20),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text(
          "Delete Task?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}