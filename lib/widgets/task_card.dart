import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Color _getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF2DD4BF);
      default:
        return const Color(0xFF8B94A3);
    }
  }

  IconData _getCategoryIcon() {
    switch (task.category.toLowerCase()) {
      case 'school':
        return Icons.school_rounded;
      case 'personal':
        return Icons.person_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'work':
        return Icons.work_rounded;
      default:
        return Icons.checklist_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF101521).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isOverdue ? const Color(0xFFFF6B6B).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.12),
                  width: 1.2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getPriorityColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(_getCategoryIcon(), color: _getPriorityColor(), size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  letterSpacing: -0.4,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  color: task.isCompleted ? Colors.white54 : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 14,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 13,
                                    color: isOverdue ? const Color(0xFFFF6B6B) : Colors.white54,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formatDate(task.dueDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isOverdue ? const Color(0xFFFF6B6B) : Colors.white54,
                                      fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => onToggle(!task.isCompleted),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: task.isCompleted 
                                    ? const Color(0xFF6C5CE7) 
                                    : Colors.white24,
                                width: 2,
                              ),
                              color: task.isCompleted 
                                  ? const Color(0xFF6C5CE7) 
                                  : Colors.transparent,
                            ),
                            child: task.isCompleted 
                                ? const Icon(Icons.check, color: Colors.white, size: 16) 
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
